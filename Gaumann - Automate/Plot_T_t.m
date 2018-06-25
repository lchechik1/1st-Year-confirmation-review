%% PLOT y-Z TEMPERATURE FIELD - GAUMANN

function Plot_T_t(x_val,y_val,z_val,T_field,l,T_m,q,v)

% Create a new figure (full screen)
figure('units','normalized','outerposition',[0 0 1 1])

% Calculate time values
t = x_val./v;

% Plot 5 lines (for first 5 layers)
midpoint_y = find(y_val==0);
for ii = 0:5
    z_index = find(z_val==-l.*ii);
    
    T_field_plot = squeeze(T_field(midpoint_y,:,z_index));
    plot(t, T_field_plot); hold on;
end

plot([min(t) max(t)], [T_m T_m], 'k');

set ( gca, 'xdir', 'reverse' )

% Save figure and close
savefig(['E:\Lev\Documents\Rosenthal_Figures\Figures\Tt\Tt_Plot P' num2str(q) ' V' num2str(v) ' .fig'])
saveas(gcf,['E:\Lev\Documents\Rosenthal_Figures\PNGs\Tt\Tt_Plot P' num2str(q) ' V' num2str(v) ' .png'])
close(gcf)
end