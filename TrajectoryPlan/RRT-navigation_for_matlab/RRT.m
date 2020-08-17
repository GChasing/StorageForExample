%***************************************
%Author: Yaoqing Hu
%Date: 2020-04-09
%***************************************
%% ���̳�ʼ��
clear all; 
x_I=1; y_I=1;           % ���ó�ʼ��
x_G=700; y_G=700;       % ����Ŀ���
Thr=30;                 % ����Ŀ�����ֵ
Delta= 50;              % ������չ����
%% ������ʼ��
T.v(1).x = x_I;         % T������Ҫ��������v�ǽڵ㣬�����Ȱ���ʼ����뵽T������
T.v(1).y = y_I; 
T.v(1).xPrev = x_I;     % ��ʼ�ڵ�ĸ��ڵ���Ȼ���䱾��
T.v(1).yPrev = y_I;
T.v(1).dist=0;          % �Ӹ��ڵ㵽�ýڵ�ľ��룬�����ȡŷ�Ͼ���
T.v(1).indPrev = 0;     % 
%% ��ʼ������������
figure(1);
ImpRgb=imread('map.png');
Imp=rgb2gray(ImpRgb);
imshow(Imp)
xL=size(Imp,1);%��ͼx�᳤��
yL=size(Imp,2);%��ͼy�᳤��
hold on
plot(x_I, y_I, 'ro', 'MarkerSize',5, 'MarkerFaceColor','r');
plot(x_G, y_G, 'go', 'MarkerSize',5, 'MarkerFaceColor','g');% ��������Ŀ���
count=1;
for iter = 1:3000
    p_rand=[];
    %Step 1: �ڵ�ͼ���������һ����x_rand
    %��ʾ���ã�p_rand(1),p_rand(2)����ʾ�����в����������
    p_rand(1)=ceil(rand()*xL); % rand()���ɵ���0~1���ȷֲ��������������700������ȡ��������Ϊ[1,800]�������
    p_rand(2)=ceil(rand()*yL);
    
    p_near=[];
    %Step 2: ���������������ҵ�����ڽ���x_near 
    %��ʾ��x_near�Ѿ�����T��
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
    %Step 3: ��չ�õ�x_new�ڵ�
    %��ʾ��ע��ʹ����չ����Delta
    p_new(1) = p_near(1) + round( ( p_rand(1)-p_near(1) ) * Delta/min_distance );
    p_new(2) = p_near(2) + round( ( p_rand(2)-p_near(2) ) * Delta/min_distance );
    
    %���ڵ��Ƿ���collision-free�����collision-free���������һ�����������collision-free�������½���ѭ��
    if ~collisionChecking(p_near,p_new,Imp) 
       continue;
    end
    count=count+1;
    
    %Step 4: ��x_new������T 
    %��ʾ���½ڵ�x_new�ĸ��ڵ���x_near
    T.v(count).x = p_new(1);         
    T.v(count).y = p_new(2); 
    T.v(count).xPrev = p_near(1);    
    T.v(count).yPrev = p_near(2);
    T.v(count).dist = min_distance;          
    
    %Step 5:����Ƿ񵽴�Ŀ��㸽�� 
    %��ʾ��ע��ʹ��Ŀ�����ֵThr������ǰ�ڵ���յ��ŷʽ����С��Thr����������ǰforѭ��
    new_distance = sqrt( ( p_new(1) - x_G )^2 + ( p_new(2) - y_G )^2 );
    if new_distance <= Thr
        plot(p_new(1), p_new(2), 'bo', 'MarkerSize',2, 'MarkerFaceColor','b'); % ����x_new
        line( [p_new(1) p_near(1)], [p_new(2) p_near(2)], 'Marker','.','LineStyle','-'); %����x_near��x_new
        line( [x_G p_new(1)], [y_G p_new(2)], 'Marker','.','LineStyle','-'); %����x_Target��x_new
        break;
    end
    
    %Step 6:��x_near��x_new֮���·��������
    %��ʾ 1��ʹ��plot���ƣ���ΪҪ�����ͬһ��ͼ�ϻ����߶Σ�����ÿ��ʹ��plot����Ҫ����hold on����
    %��ʾ 2�����ж��յ���������forѭ��ǰ���ǵð�x_near��x_new֮���·��������
    plot(p_new(1), p_new(2), 'bo', 'MarkerSize',2, 'MarkerFaceColor','b'); % ����x_new
    line( [p_new(1) p_near(1)], [p_new(2) p_near(2)], 'Marker','.','LineStyle','-'); %����x_near��x_new
    hold on;
   
    pause(0.1); %��ͣ0.1s��ʹ��RRT��չ�������׹۲�
end

%% ����·��
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
    line( [path(i,1) path(i+1,1)], [path(i,2) path(i+1,2)], 'Marker','.','LineStyle','-','color','r'); %����x_near��x_new
    hold on;
    pause(0.1); %��ͣ0.1s��ʹ��RRT��չ�������׹۲�
end