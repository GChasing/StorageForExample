% load('Map1.mat');   
load('Map2.mat');
% load('Map3.mat');

start_node = [0, 0];    % coordinate of the start node
dest_node  = [20, 12]; % coordinate of the destination node
figure(1);
clf;

show_graph = true;  % set this false to hide the graph
sampling_points = 100;
step_length_limit = 5;

graph = PRM_Builder(map, start_node, dest_node, sampling_points, step_length_limit, show_graph);
[plan_succeeded, path] = dijkstar(graph);

if(plan_succeeded)
    disp('plan succeeded! ');
else
    disp('plan failed!');
end

