function Kernel = NeighborKernelSH(CurrentKernel , AVGKer, Rate, CluNum)

smp_num = size(CurrentKernel , 1);
smp_each_class = smp_num / CluNum;

NeiNum = round( Rate *  smp_each_class);

AA = genarateNeighborhood(AVGKer , NeiNum);

Kernel = KernelGeneration(CurrentKernel , AA);

end