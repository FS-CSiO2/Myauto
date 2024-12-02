import pyautogui
import cv2
import numpy as np
import pytesseract
import time
from PIL import ImageGrab
import threading
import keyboard

def listen_for_esc(stop_event):
    # 当按下esc键时，设置全局变量stop_event为True
    keyboard.wait('esc')  #线程会阻塞直到按下esc键
    stop_event.set() #设置全局变量stop_event为True
    print("收到退出信号，停止程序")

def find_template(screen_img, template,w,h):  
    # 应用模板匹配  
    res = cv2.matchTemplate(screen_img, template, cv2.TM_CCOEFF_NORMED)  
    threshold = 0.92  # 设置匹配阈值     
    # 找到匹配的区域  
    loc = np.where(res >= threshold)  
    for pt in zip(*loc[::-1]):  
        cv2.rectangle(screen_img, pt, (pt[0] + w, pt[1] + h), (0, 0, 255), 2)     
    # 如果找到至少一个匹配项，返回最佳匹配的中心点  
    if loc[0].size > 0:  
        top_left = min(loc[1]), min(loc[0])  
        bottom_right = (top_left[0] + w, top_left[1] + h)  
        center = (int((top_left[0] + bottom_right[0]) / 2), int((top_left[1] + bottom_right[1]) / 2))  
        return center  
    return None 

#单次的查找图片动作（用来查找特殊标识，例如验证码错误图片）
def MyOncefound(image_BiaoShi):
    center_Oncefound = None
    # 加载模板图像并转换为灰度图  
    template = cv2.imread(image_BiaoShi, 0)  
    w, h = template.shape[::-1]           
    # 截取屏幕图像  
    screen_img = np.array(ImageGrab.grab())  
    screen_gray = cv2.cvtColor(screen_img, cv2.COLOR_BGR2GRAY)            
    # 查找模板图像  
    center_Oncefound = find_template(screen_gray, template,w,h)
    # 找到就返回1，否则返回0  
    if center_Oncefound is not None:
        time.sleep(0.05)
        return 1
    else:
        time.sleep(0.05)
        return 0

def MyclickLoop(image_path):
    while True:
        center_Loop = None
        # 加载模板图像并转换为灰度图  
        template = cv2.imread(image_path, 0)  
        w, h = template.shape[::-1]           
        # 截取屏幕图像  
        screen_img = np.array(ImageGrab.grab())  
        screen_gray = cv2.cvtColor(screen_img, cv2.COLOR_BGR2GRAY)            
        # 查找模板图像  
        center_Loop = find_template(screen_gray, template,w,h)  
        if center_Loop is not None:
            # 转换坐标到屏幕坐标并点击  
            screen_xLoop, screen_yLoop = center_Loop  
            screen_pointLoop = (screen_xLoop, screen_yLoop)  
            # 等待0.1秒  
            time.sleep(0.1)
            pyautogui.click(screen_pointLoop)
            time.sleep(0.1)
            break             
        else:
            # 等待0.1秒  
            time.sleep(0.1) 

def Blur(gray_frame, binary_num):#binary_num是二值化阈值
    # 灰度图像二值化处理
    _, binary_image = cv2.threshold(gray_frame, binary_num, 255, cv2.THRESH_BINARY)

    # 中值滤波去噪
    median_filtered = cv2.medianBlur(binary_image, 3)
    # cv2.imshow('Median Filtering', median_filtered) #显示中值滤波后的图像
    #初步识别数字
    numbers = pytesseract.image_to_string(median_filtered, config='--psm 6 outputbase digits')
    #print(numbers)
    # 连续调用 replace() 方法去除无关字符
    RP_Numbers = numbers.replace("+", "").replace("-", "").replace("*", "").replace("/", "") \
            .replace("=", "").replace("≠", "").replace("<", "").replace(">", "") \
            .replace("≤", "").replace("≥", "").replace(".", "").replace("∑", "") \
            .replace("∫", "").replace("α", "").replace("β", "").replace("γ", "").replace("θ", "").replace("λ", "") \
            .replace("⊂", "").replace("⊃", "").replace("⊆", "").replace("⊇", "") \
            .replace("∪", "").replace("∩", "").replace("∞", "").replace("∅", "") \
            .replace("∈", "").replace("∉", "").replace("⊕", "").replace("⊗", "").replace(" ", "").replace("\n", "")
    # 调整后的数字
    print(f"RP_Numbers={RP_Numbers},binary_num={binary_num}")
    return RP_Numbers

def main_task(stop_event):
    while not stop_event.is_set(): # 持续循环直到收到停止信号
        time.sleep(0.1)
        # 指定截取区域的左上角和右下角坐标
        left, top, right, bottom = 1054, 573, 1133, 595 #验证码区域，根据实际情况调整
        screenshot = pyautogui.screenshot(region=(left, top, right - left, bottom - top))

        # 将截图转换为NumPy数组
        frame = np.array(screenshot)

        # OpenCV读取的图片通道顺序是BGR，需要转换为RGB
        frame = cv2.cvtColor(frame, cv2.COLOR_RGB2BGR)

        # 转换为灰度图
        gray_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        # 调用Blur函数进行二值化去噪处理和初步识别数字,获取返回值,判断位数是否小于4，如果小于4则调整参数重新识别，连续读取3次都不为4位，则点击验证码刷新
        RP_Numbers2=Blur(gray_frame, 185)
        if len(RP_Numbers2) != 4:
            RP_Numbers2=Blur(gray_frame, 190)
        if len(RP_Numbers2) != 4:
            RP_Numbers2=Blur(gray_frame, 195)
        if len(RP_Numbers2) != 4:
            pyautogui.click(1078, 584) #点击验证码刷新
            time.sleep(0.1)
            pyautogui.click(950, 584)#点击输入框，然后跳过当前循环重新开始
            continue
        #点击输入框并输入数字
        pyautogui.click(950, 584)
        time.sleep(0.1)
        pyautogui.hotkey('ctrl', 'a')
        #输入数字
        time.sleep(0.1)
        pyautogui.typewrite(RP_Numbers2)
        time.sleep(0.1)
        #点击登录
        MyclickLoop("E:\\OAauto\\OAAuto6\\PNG\\UP.png")
        # 查找登录按钮图片
        time.sleep(1)
        pd = 1
        pd = MyOncefound("E:\\OAauto\\OAAuto6\\PNG\\UP.png")#查到登录按钮图片就继续循环，查不到登录按钮图片就说明成功了
        if pd == 0:
            MyclickLoop("E:\\OAauto\\OAAuto6\\PNG\\yes.png")#点击确定
            break
        
def main():
    stop_event = threading.Event() # 创建一个事件对象，用于控制主任务的停止
    # 创建并启动主任务线程
    main_thread = threading.Thread(target=main_task, args=(stop_event,))
    main_thread.start()

    # 创建并启动监控 'esc' 键的线程
    escape_thread = threading.Thread(target=listen_for_esc, args=(stop_event,))
    escape_thread.daemon = True # 设置为守护线程，主线程退出时，该线程也会退出
    escape_thread.start()
    # 等待主任务线程完成
    main_thread.join()
    print("程序已退出")

# 延时3秒后运行主函数
time.sleep(3)
main()
print("结束")
