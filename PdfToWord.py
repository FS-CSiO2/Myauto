from pdf2docx import Converter

def pdf_to_word(pdf_path, word_path):
    # 创建 Converter 对象
    cv = Converter(pdf_path)
    
    # 执行转换
    cv.convert(word_path, start=0, end=None)  # start 和 end 用于指定转换的页码范围，None 表示全部
    
    # 关闭 Converter 对象
    cv.close()

# 示例用法
print("请把文件放在和pdf文件同一目录下")
pdf_path = input("请输入源PDF文件名: ")
pdf_path = pdf_path + ".pdf"
word_path = input("请输入保存Word文件名: ")
word_path = word_path + ".docx"
pdf_to_word(pdf_path, word_path)

