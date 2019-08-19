from qqwry import QQwry
q=QQwry()

#filename可以是qqwry.dat的文件名也可以是bytes类型的文件内容
#当参数loadindex=False时 加载速度快进程内存少查询速度慢
#当参数loadindex=True时 加载速度慢进程内存多查询速度快
q.load_file('qqwry.dat',loadindex=False)
result=q.lookup('8.8.8.8')
print(result)
