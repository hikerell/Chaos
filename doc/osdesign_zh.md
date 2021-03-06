# Chaos内核设计文档 #

  Chaos是一个新的操作系统内核，是为了探求操作系统内部运行原理而由hikerell和leaomate提出来的。

  简单来说，我们想实现从头实现一个新的、简单的、可运行的操作系统内核，或许在不久的将来，它不仅能在传统的x86系列CPU上运行，还可以用于物联网芯片上。

  此外，要注意的是，本项目基于NASM和Golang实现。Golang是一门带有垃圾回收等高级机制的高级语言，为了借其实现一个操作系统，我们对内核组织有新的理解，即引入
runtime层，后面会详细讲解。

  本项目的暂时的目录组织如下：
  .
  |-- doc  ： 项目文档统一放在该目录下
  |-- bin  ： 编译后生成的镜像
  |-- pkg  ： 源码编译后自动生成的库
  |-- src  ： 源码目录
      |-- boot     ： 启动模块
      |-- kernel   ： 内核组件统一放于此目录下
      |-- runtime  ： 提供给非内核层的运行时接口
      |-- dirvers  ： 驱动
          |-- mm   ： 内存作为程序不可轻易访问的资源
          |-- fs   ： 文件系统驱动
          |-- kb   ： 键盘驱动
          |-- mouse  ： 鼠标驱动
          |-- moniter  ： 显示器驱动

## 一、我们对内核的理解 ##
  
  这一部分讲述我们目前对内核（Chaos）的理解，水平有限，有错误的地方烦劳各路高手不吝赐教。
  
  一般认为，内核是设备管理与资源管理的底层实现，对于现代操作系统内核，它必须支持以下几个方面：
      * 多任务多用户实时、稳定交互
      * 网络功能
      * 高安全性
  
  我们基于以上几点对重新对内核组织结构进行了认真的分析与研究。
      × 1、内核独立性。操作系统既独立与硬件，也独立于上层用户应用程序。换句话说，内核只是中间人，它只负责安全地将用户需求传递给设备和资源，并且保证设备与资源理解服务需求，最后将设备与资源的响应回馈给上层用户/应用。
      × 2、内核排它性。作为整个计算系统中最重要的一环，内核不信任除本身之外的任何指令/数据。举例来说，在现有的操作系统实现中，驱动一直是内核的一个重要组成部分，而在Chaos中，驱动仅仅是完成内核与设备/资源交流的第三方组件，当由设备方/资源方提供，不属于内核的可信任对象，不应当共享内核权限，并且，为防止用户程序绕过内核直接访问设备，驱动权限必须高于用户应用权限。
           这里的设备和资源包括但不限于内存、显示器、文件系统等。
           有代表性的是，处理器/芯片自身是内核的实体存在。

  为了支持应用程序运行，内核组件分离出了runtime层，该层类似为Java语言中的虚拟机或动态语言的解释器，它既为基于Golang的应用程序提供环境，也为用户程序请求设备/资源服务提供接口/规范。
