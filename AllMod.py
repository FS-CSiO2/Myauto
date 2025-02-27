import cv2
import pyautogui   # type: ignore
import time 
import numpy as np 
from PIL import ImageGrab 
import openpyxl  # 用于读取Excel文件
import time      # 用于暂停执行
import cv2       # 用于图像处理
import numpy as np  # 用于数组操作
import pyautogui  # 用于模拟鼠标和键盘操作
import os         # 用于文件和路径操作
import pyperclip  # 用于剪贴板操作
import webbrowser # 用于打开网页

def foundImg(path):# 彩图检索函数，查找图片返回中心点   
    template = cv2.imread(path) # 读取模板图像  
    _, w, h= template.shape[::-1] # 获取模板图像的w宽度和h高度    
    screen = pyautogui.screenshot() # 获取屏幕截图   
    screen2 = cv2.cvtColor(np.array(screen), cv2.COLOR_RGB2BGR) # 将屏幕截图转换为OpenCV图像
    result = cv2.matchTemplate(screen2, template, cv2.TM_CCOEFF_NORMED) # 在屏幕截图中进行模板匹配
    min_val, max_val, min_loc, max_loc = cv2.minMaxLoc(result) # 获取匹配结果中最大值的位置
    center = (max_loc[0] + (w / 2)  , max_loc[1] + (h / 2)) # 计算匹配位置的中心点
    threshold = 0.92 # 设置匹配阈值
    if max_val > threshold: # 如果匹配值大于阈值，则返回中心点
        return center

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

#循环查找图片函数，查不到不会停止，查到会点击并break跳出当前循环
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
            break             
        else:
            # 等待0.1秒  
            time.sleep(0.1) 

#灰度图单次的查找图片动作（一般用来查找特殊标识）
def MyOncefound(image):
    center_Oncefound = None
    # 加载模板图像并转换为灰度图  
    template = cv2.imread(image, 0)  
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

#灰度图单次的点击图片动作（找到图片就点击一次）
def MyOncefoundClick(image):
    center_Oncefound = None
    # 加载模板图像并转换为灰度图  
    template = cv2.imread(image, 0)  
    w, h = template.shape[::-1]           
    # 截取屏幕图像  
    screen_img = np.array(ImageGrab.grab())  
    screen_gray = cv2.cvtColor(screen_img, cv2.COLOR_BGR2GRAY)            
    # 查找模板图像  
    center_Oncefound = find_template(screen_gray, template,w,h)
    # 找到就点击一次，否则等待0.1秒
    if center_Oncefound is not None:
        screen_xLoop, screen_yLoop = center_Oncefound  
        screen_pointLoop = (screen_xLoop, screen_yLoop)  
        # 等待0.1秒  
        time.sleep(0.1)
        pyautogui.click(screen_pointLoop)
    else:
        time.sleep(0.1)

#彩图检索函数，检索到就会进行一次点击然后break，否则就继续不停循环检索
def ColorOnceClickLoop(path):
    while True:
        # 等待0.1秒，避免过于频繁的屏幕截图和模板匹配
        time.sleep(0.1)
        # 读取模板图像
        template = cv2.imread(path)
        # 获取模板图像的w宽度和h高度
        _, w, h= template.shape[::-1]
        # 获取屏幕截图
        screen = pyautogui.screenshot(region=(0, 0, 1920, 1080))
        # 将屏幕截图转换为OpenCV图像
        screen2 = cv2.cvtColor(np.array(screen), cv2.COLOR_RGB2BGR)
        # 在屏幕截图中进行模板匹配
        result = cv2.matchTemplate(screen2, template, cv2.TM_CCOEFF_NORMED)
        # 获取匹配结果中最大值的位置
        min_val, max_val, min_loc, max_loc = cv2.minMaxLoc(result)
        # 计算匹配位置的中心点
        center = (max_loc[0] + (w / 2)  , max_loc[1] + (h / 2))
        # 设置匹配阈值
        threshold = 0.92
        # 如果匹配值大于阈值，模拟鼠标左键点击
        if max_val > threshold:
            pyautogui.click(center)
            break

def ColorClickOnce(path,LorR,l1=0,l2=0): # 彩图检索函数，点击一次图片（找不到就跳过）    
    center = foundImg(path) # 传递路径给查找图片返回中心点   
    if center is not None: # 如果找到图片，则模拟鼠标左键点击
        # 将元组转换为列表
        center_list = list(center)
        # 修改各个分量
        center_list[0] += l1
        center_list[1] += l2
        center = tuple(center_list)
        # 将列表转换回元组
        if LorR == "L":
            pyautogui.mouseDown(center) # 模拟鼠标左键点击坐标
            time.sleep(0.05)
            pyautogui.mouseUp(center)
            print(f"左键点击了坐标{center}")
        elif LorR == "R":
            pyautogui.mouseDown(center,button='right') # 模拟鼠标右键点击坐标
            time.sleep(0.05)
            pyautogui.mouseUp(center,button='right')
            print(f"右键点击了坐标{center}")
        else:
            print("LorR参数错误")
    else:
        print(f"未找到图片:{path}，跳过")
    time.sleep(0.1) 

def Color_Found_Move_Loop(path,l1=0,l2=0): #查找图片坐标（找不到就一直找）
    while True:
        center = foundImg(path) 
        if center is not None:                  
            center_list = list(center)  # 将元组转换为列表       
            center_list[0] += l1    # 修改各个分量
            center_list[1] += l2
            center = tuple(center_list)  
            pyautogui.moveTo(center)
            print(f"鼠标移动到坐标{center}")
            break

# 模拟复制键盘动作 
def ctrlC(i = 0.1):
    pyautogui.keyDown('ctrl') 
    time.sleep(i) 
    pyautogui.press('c')
    time.sleep(i)   
    pyautogui.keyUp('ctrl') 

def ctrlV(i = 0.1): # 模拟粘贴键盘动作，默认间隔0.1秒
    pyautogui.keyDown('ctrl') 
    time.sleep(i) 
    pyautogui.press('v')
    time.sleep(i)   
    pyautogui.keyUp('ctrl')  

