# 高级练习12 千兆通信中发送链路的 IP 和 UDP 校验和计算 

## 一、练习内容

​	在发送的数据帧中添加校验和，包括IP校验和与UDP校验和。

## 二、系统框图

![1581412575352](E:\Exercise\FPGA\v3edu\test12_add_check_sum\doc\assets\1581412575352.png)

## 三、设计分析

​	关键在于时序分析，对于IP校验和与UDP校验和，总的实现原理差不多。故以IP校验和为例，绘制了如下的时序分析图。

![1581412774292](E:\Exercise\FPGA\v3edu\test12_add_check_sum\doc\assets\1581412774292.png)

​	为了后面在原来数据的基础上添加校验和，这里先将数据存储到RAM中，待数据接收完成后，再从RAM中将数据读取出来，再添加上去。

​	总的来说，问题不是很大，因为最难的时序分析部分已经完成，这里只是代码实现而已，而这部分通常都更简单。

## 四、练习步骤

​	添加校验和与计算校验和两部分基本上是独立的，可以分别进行查看，代码编写也是可以分层进行的。

### 1.代码编写

​	按照时序图进行代码的编写，问题应该不是很大。

### 2.软件仿真

​	使用modelsim进行软件仿真，查看校验和是否添加进去。

## 五、实际波形仿真

### 1.总体统筹

​	总体上主要有三个部分组成，分别是ip checksum的实现，udp checksum的实现，以及在原有数据的基础上添加checksum。在下图中分别用不用颜色作为标记。

![1581427283629](E:\Exercise\FPGA\v3edu\test12_add_check_sum\doc\assets\1581427283629.png)

### 2.局部抓牢

​	接下来分模块进行说明。

​	首先是ip checksum的计算，如下图所示。数据从0x45开始计算，计数刚好到22，到41结束，与设计的波形相符。其余部分的波形也与设计的波形一致，再经过一系列的计数，最终得到的checksum为0x798e；

![1581427552386](E:\Exercise\FPGA\v3edu\test12_add_check_sum\doc\assets\1581427552386.png)

​	然后是udp checksum的计算，和ip checksum的时序基本差不多，最终得到的checksum为0x3968，如下图所示；

![1581427992785](E:\Exercise\FPGA\v3edu\test12_add_check_sum\doc\assets\1581427992785.png)

![1581428072983](E:\Exercise\FPGA\v3edu\test12_add_check_sum\doc\assets\1581428072983.png)

​	最后，看看我们添加checksum的过程，这需要从RAM中将数据读取出来，然后再添加checksum。这里有一点就是读出来的数据相对于地址计数往后偏移一个时钟计数单元，这样的话，对于checksum的添加其需要加1才能与数据同步，如下图所示。

![1581428356096](E:\Exercise\FPGA\v3edu\test12_add_check_sum\doc\assets\1581428356096.png)

![1581428406284](E:\Exercise\FPGA\v3edu\test12_add_check_sum\doc\assets\1581428406284.png)

### 3.结果清晰

​	总的来说，本次实验还算成功，实现了基本的功能，要说需要注意的话，还是checksum是16bit的数据，这是需要修正的。

![1581428453725](E:\Exercise\FPGA\v3edu\test12_add_check_sum\doc\assets\1581428453725.png)

## 六、总结与讨论

### 1.RAM IP核的调用

​	分析比实现更重要，对于RAM的使用，这里做简单的总结。

​	常用的是伪双口RAM	

​	参考下列链接。

[Vivado（2017.1）中 BRAM IP核的配置与使用]: http://xilinx.eetrend.com/d6-xilinx/blog/2018-10/13759.html
[XILINX之RAM使用指南（加个人总结）]: https://www.cnblogs.com/chengqi521/p/6831439.html

