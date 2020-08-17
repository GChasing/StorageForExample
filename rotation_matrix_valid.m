clear all;
phi = pi/3;
theta = pi/4;
rotation_s = [1     sin(phi)*tan(theta)     cos(phi)*tan(theta);
              0     cos(phi)                -sin(phi);
              0     sin(phi)/cos(theta)     cos(phi)/cos(theta);];
rotation_s_T = rotation_s';
rotation_s_T_inv = inv(rotation_s');
rotation_s_inv_T = inv(rotation_s)';

rotation = [1         0              -sin(theta);
            0       cos(phi)       sin(phi)*cos(theta);
            0        -sin(phi)      cos(phi)*cos(theta);];
            