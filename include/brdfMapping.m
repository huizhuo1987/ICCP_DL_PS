%% This function maps the lighting, surface normals, view directions to
% the intensity based on the vectoried BRDF, and allows for the
% interpolation if the required value is off the sampling grid.

% this script was written based on the format given by MERL database
% you can modify it if you change the database

% input:
% 1. ini_in: lighting diection, 3*1 vector
% 2. ini_out: view diection, 3*1 vector
% 3. ini_normal: surface normals
% 4. brdf: vectorized BRDF, based on 1 degree sampling. 

% output:
% intensity for the particular pixel



function intensity = brdfMapping(ini_in, ini_out, ini_normal, brdf)

THETA_H = 90;
THETA_D = 90; 
PHI_D = 360;
r_scale = 1.0/1500.0;
g_scale = 1.15/1500.0;
b_scale = 1.66/1500.0;

normal = [0; 0; 1];
bi_normal = [0; 1; 0];
t_normal = [1; 0; 0];

theta_normal = acos(ini_normal(3));
fi_normal = atan2(ini_normal(2), ini_normal(1));

ini_temp = rotate_vector(ini_in, normal,  -pi/2 - fi_normal); %ori
ini_temp = rotate_vector(ini_temp, t_normal,  -theta_normal);

% ini_temp = rotate_vector(ini_in, t_normal,  -theta_normal);
% ini_temp = rotate_vector(ini_temp, normal,  -pi/2 - fi_normal); %-fi_normal


theta_in = acos(max(-1, ini_temp(3)));
fi_in = atan2(ini_temp(2), ini_temp(1));
%fi_in = atan2(ini_in(2), ini_in(1));

out_temp = rotate_vector(ini_out, normal,  -pi/2 - fi_normal);
out_temp = rotate_vector(out_temp, t_normal,  -theta_normal);

% out_temp = rotate_vector(ini_out, t_normal,  -theta_normal);
% out_temp = rotate_vector(out_temp, normal,  -pi/2 - fi_normal); %-fi_normal


theta_out = acos(max(-1, out_temp(3)));
fi_out = atan2(out_temp(2), out_temp(1));    
%fi_out = atan2(ini_out(2), ini_out(1));

in_vec_z = cos(theta_in);
proj_in_vec = sin(theta_in);
in_vec_x = proj_in_vec*cos(fi_in);
in_vec_y = proj_in_vec*sin(fi_in);
in = [in_vec_x; in_vec_y; in_vec_z];
in = in./(norm(in));

out_vec_z = cos(theta_out);
proj_out_vec = sin(theta_out);
out_vec_x = proj_out_vec*cos(fi_out);
out_vec_y = proj_out_vec*sin(fi_out);
out = [out_vec_x; out_vec_y; out_vec_z];
out = out./(norm(out));    

half = (in + out)/2;
half = half./(norm(half));

half = real(half);

theta_half = acos(half(3));
fi_half = atan2(half(2), half(1));


% diff_temp = rotate_vector(in,  bi_normal , -theta_half);
% diff = rotate_vector(diff_temp,  normal , -fi_half);

diff_temp = rotate_vector(in,  normal , -fi_half);
diff = rotate_vector(diff_temp,  bi_normal , -theta_half);

diff = real(diff);

theta_diff = acos(diff(3));
fi_diff = atan2(diff(2), diff(1));

[phi_diff_idx_l,  id_p, phi_diff_idx_h] = phi_diff_index(fi_diff, PHI_D);
[theta_diff_idx_l,  id_td, theta_diff_idx_h] = theta_diff_index(theta_diff, THETA_D);
[theta_half_idx_l, id_th, theta_half_idx_h]= theta_half_index(theta_half, THETA_H);
	if ((phi_diff_idx_l == phi_diff_idx_h) || (theta_diff_idx_l == theta_diff_idx_h) ...
		|| (theta_half_idx_l == theta_half_idx_h))

		ind = (round(id_p)) + ...
			  (round(id_td) - 1)* PHI_D/2 +...
			  (round(id_th) - 1)* PHI_D/2 * THETA_D;
		vR = brdf(ind) * r_scale;
		vG = brdf(ind + THETA_H*THETA_D*PHI_D/2) * g_scale;
		vB = brdf(ind + THETA_H*THETA_D*PHI_D) * b_scale;
		intensity = [vR; vG; vB];
	else
		[PHI, THE_D, THE_H] = ndgrid(phi_diff_idx_l:phi_diff_idx_h, theta_diff_idx_l:theta_diff_idx_h, theta_half_idx_l:theta_half_idx_h);
		ind = PHI(:) + (THE_D(:) - 1) * PHI_D/2 + (THE_H(:) - 1)* PHI_D/2 * THETA_D;

		red_val = max([zeros(length(ind), 1) brdf(ind)* r_scale], [], 2);
		green_val = max([zeros(length(ind), 1) brdf(ind + THETA_H*THETA_D*PHI_D/2) * g_scale], [], 2);
		blue_val = max([zeros(length(ind), 1) brdf(ind + THETA_H*THETA_D*PHI_D) * b_scale], [], 2);

		FR = griddedInterpolant(PHI, THE_D, THE_H, reshape(red_val, [2 2 2]));
		FG = griddedInterpolant(PHI, THE_D, THE_H, reshape(green_val, [2 2 2]));
		FB = griddedInterpolant(PHI, THE_D, THE_H, reshape(blue_val, [2 2 2]));

		vR = FR(id_p, id_td, id_th);
		vG = FG(id_p, id_td, id_th);
		vB = FB(id_p, id_td, id_th);
		intensity = [vR; vG; vB];
	end
end

function out = rotate_vector(vec, axis, angle)
    cos_ang = cos(angle);
    sin_ang = sin(angle);
    out = vec.*cos_ang;
    temp = vec'*axis;
    temp = temp*(1.0 - cos_ang);
    out = out + axis.*temp;
    cro_vec = cross(axis, vec);
    out = out + cro_vec.*sin_ang;
end

function [idx_l, idx, idx_h] = theta_half_index(theta_half, sampling_rate)
    
    theta_half_deg = (theta_half /(pi/2)) * sampling_rate;
    temp = theta_half_deg * sampling_rate;
    temp = sqrt(temp);
    %temp = int32(temp);
    temp_h = ceil(temp);
    temp_l = floor(temp);
    
    idx = convert(temp, sampling_rate);
    idx_h = convert(temp_h, sampling_rate);
    idx_l = convert(temp_l, sampling_rate);
    if (idx_h == idx_l)
        idx = idx_h;
    end
    %temp = int32(theta_half_deg);%uint32(temp);

end

function [idx_l, idx, idx_h] = theta_diff_index(theta_diff, sampling_rate)
    temp = theta_diff / (0.5*pi)* sampling_rate;
    temp_h = ceil(temp);
    temp_l = floor(temp);
    
    idx = convert(temp, sampling_rate);
    idx_h = convert(temp_h, sampling_rate);
    idx_l = convert(temp_l, sampling_rate);
    if (idx_h == idx_l)
        idx = idx_h;
    end    
end


function [idx_l, idx, idx_h] = phi_diff_index(phi_diff, sampling_rate)
    if (phi_diff < 0.0)
        phi_diff = pi + phi_diff;
    end
    temp = phi_diff /pi * sampling_rate/2;
    temp_h = ceil(temp);
    temp_l = floor(temp);
    
    idx= convert(temp, sampling_rate/2);
    idx_h = convert(temp_h, sampling_rate/2);
    idx_l = convert(temp_l, sampling_rate/2);
    if (idx_h == idx_l)
        idx = idx_h;
    end
end

function idx = convert(temp, sampling_rate)
    if(temp <= 0)
        idx = 1;
    elseif(temp < sampling_rate) 
        %temp = theta_half_deg * sampling_rate;
        %temp = sqrt(temp);
        %temp = int32(temp);      
        idx = temp + 1;
    else
        idx = sampling_rate;
        %end
    end
end