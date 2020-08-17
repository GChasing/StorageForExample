%***************************************
%Author: Yaoqing Hu
%Date: 2020-04-09
%***************************************
%% 流程初始化
clear all; 
x_I=1; y_I=1;           % 设置初始点
x_G=700; y_G=700;       % 设置目标点
Thr=30;                 % 设置目标点阈值
Delta= 50;              % 设置扩展步长
%% 建树初始化
T.v(1).x = x_I;         % T是我们要做的树，v是节点，这里先把起始点加入到T里面来
T.v(1).y = y_I; 
T.v(1).xPrev = x_I;     % 起始节点的父节点仍然是其本身
T.v(1).yPrev = y_I;
T.v(1).dist=0;          % 从父节点到该节点的距离，这里可取欧氏距离
T.v(1).indPrev = 0;     % 
%% 开始搜索并构建树
figure(1);
ImpRgb=imread('map.png');
Imp=rgb2gray(ImpRgb);
imshow(Imp)
xL=size(Imp,1);%地图x轴长度
yL=size(Imp,2);%地图y轴长度
hold on
plot(x_I, y_I, 'ro', 'MarkerSize',5, 'MarkerFaceColor','r');
plot(x_G, y_G, 'go', 'MarkerSize',5, 'MarkerFaceColor','g');% 绘制起点和目标点
count=1;
for iter = 1:3000
    p_rand=[];
    %Step 1: 在地图中随机采样一个点x_rand
    %提示：用（p_rand(1),p_rand(2)）表示环境中采样点的坐标
    p_rand(1)=ceil(rand()*xL); % rand()生成的是0~1均匀分布的随机数，乘以700再向上取整，数便为[1,800]间的整数
    p_rand(2)=ceil(rand()*yL);
    
    p_near=[];
    %Step 2: 遍历树，从树中找到最近邻近点x_near 
    %提示：x_near已经在树T里
    min_distance = inf;
    for i=1:count
        distance = sqrt( ( T.v(i).x - p_rand(1) )^2 + ( T.v(i).y - p_rand(2) )^2 );
        if distance < min_distance
            min_distance = distance;
            index = i;
        end
    end
    p_near(1) = T.v(index).x;
    p_near(2) = T.v(index).y;
    
    p_new=[];
    %Step 3: 扩展得到x_new节点
    %提示：注意使用扩展步长Delta
    p_new(1) = p_near(1) + round( ( p_rand(1)-p_near(1) ) * Delta/min_distance );
    p_new(2) = p_near(2) + round( ( p_rand(2)-p_near(2) ) * Delta/min_distance );
    
    %检查节点是否是collision-free，如果collision-free，则进行下一步，如果不是collision-free，则重新进入循环
    if ~collisionChecking(p_near,p_new,Imp) 
       continue;
    end
    count=count+1;
    
    %Step 4: 将x_new插入树T 
    %提示：新节点x_new的父节点是x_near
    T.v(count).x = p_new(1);         
    T.v(count).y = p_new(2); 
    T.v(count).xPrev = p_near(1);    
    T.v(count).yPrev = p_near(2);
    T.v(count).dist = min_distance;          
    
    %Step 5:检查是否到达目标点附近 
    %提示：注意使用目标点阈值Thr，若当前节点和终点的欧式距离小于Thr，则跳出当前for循环
    new_distance = sqrt( ( p_new(1) - x_G )^2 + ( p_new(2) - y_G )^2 );
    if new_distance <= Thr
        plot(p_new(1), p_new(2), 'bo', 'MarkerSize',2, 'MarkerFaceColor','b'); % 绘制x_new
        line( [p_new(1) p_near(1)], [p_new(2) p_near(2)], 'Marker','.','LineStyle','-'); %连接x_near和x_new
        line( [x_G p_new(1)], [y_G p_new(2)], 'Marker','.','LineStyle','-'); %连接x_Target和x_new
        break;
    end
    
    %Step 6:将x_near和x_new之间的路径画出来
    %提示 1：使用plot绘制，因为要多次在同一张图上绘制线段，所以每次使用plot后需要接上hold on命令
    %提示 2：在判断终点条件弹出for循环前，记得把x_near和x_new之间的路径画出来
    plot(p_new(1), p_new(2), 'bo', 'MarkerSize',2, 'MarkerFaceColor','b'); % 绘制x_new
    line( [p_new(1) p_near(1)], [p_new(2) p_near(2)], 'Marker','.','LineStyle','-'); %连接x_near和x_new
    hold on;
   
    pause(0.1); %暂停0.1s，使得RRT扩展过程容易观察
end

%% 画出路径
T_LIST = zeros(size(T.v, 2), 5);
for i=1:size(T.v, 2)
    T_LIST(i,1) = T.v(i).x;
    T_LIST(i,2) = T.v(i).y;
    T_LIST(i,3) = T.v(i).xPrev;
    T_LIST(i,4) = T.v(i).yPrev;
    T_LIST(i,5) = i;
end

path = [];
path_count = 1;
path(path_count,1) = x_G;
path(path_count,2) = y_G;
path_count = path_count + 1;
path(path_count,1) = p_new(1);
path(path_count,2) = p_new(2);
n_index = node_index(T_LIST, p_new(1), p_new(2));
path_count = path_count + 1;
path(path_count,1) = T_LIST(n_index,3);
path(path_count,2) = T_LIST(n_index,4);
while path(path_count,1) ~= x_I || path(path_count,2) ~= y_I
    new_n_index = node_index(T_LIST, path(path_count,1), path(path_count,2));
    path_count = path_count + 1;
    path(path_count,1) = T_LIST(new_n_index,3);
    path(path_count,2) = T_LIST(new_n_index,4);
    n_index = new_n_index;
end

for i=size(path,1)-1 :-1: 1
    line( [path(i,1) path(i+1,1)], [path(i,2) path(i+1,2)], 'Marker','.','LineStyle','-','color','r'); %连接x_near和x_new
    hold on;
    pause(0.1); %暂停0.1s，使得RRT扩展过程容易观察
end