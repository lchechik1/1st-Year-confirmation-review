% % SET UP LOOP THROUGH ALL POWER/VELOCITY
clear
tic

% q_min = 50;
% q_max = 500;
% q_step = 10;
% q_val = q_min:q_step:q_max;
q_val = [40:75:190];

% v_min = 0e-3;
% v_max = 5000e-3;
% v_step = 50e-3;
% v_val = v_min:v_step:v_max;
% % To get higher resolution at low velocities
% v_val = [0 5e-3 10e-3 15e-3 20e-3 25e-3 30e-3 40e-3 v_val(2:end)];
v_val = [300:450:2100]*1e-3;

for ii = 1:length(q_val)
    for jj = 1:length(v_val)
        ['P: ' num2str(ii) '/' num2str(length(q_val)) ', V: ' num2str(jj) '/' num2str(length(v_val))]
        All_Melt_Properties((ii-1).*length(v_val)+jj) = Gaumann_Setup(q_val(ii), v_val(jj));
    end
end

save('All_Melt_Properties.mat','All_Melt_Properties')
 
Properties = struct2table(All_Melt_Properties);
% Properties(:,'Power')

figure('units','normalized','outerposition',[0 0 1 1])

[Q,V] = meshgrid(q_val,v_val);
max_temps = table2array(Properties(:,'max_temp'));
max_temps_matrix = reshape(max_temps,[length(v_val) length(q_val)]);

surf(Q, V, max_temps_matrix, 'edgecolor','none');

toc