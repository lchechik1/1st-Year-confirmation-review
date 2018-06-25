%% PLOT X-Z TEMPERATURE FIELD - GAUMANN

function Melt_Properties = Plot_T_field_X_Z(x_val,y_val,z_val,T_field,l,T_0,T_m,r_b,q,v,Melt_Properties)

% Create a new figure (full screen)
figure('units','normalized','outerposition',[0 0 1 1])

% Create X-Z grid
[X,Z] = meshgrid(x_val,z_val);

% Plot X-Z surface
midpoint = find(y_val==0);
T_field_plot = squeeze(T_field(midpoint,:,:));
surf(X, Z, T_field_plot.','EdgeColor','none'); hold on;

% Add black line to show melt pool boundary
cont_XZ = contour3(x_val,z_val,T_field_plot.',[T_m, T_m], 'black'); hold on;

% Add lines to show first 2 layers
% Viewing from above, so 4000 means line always visible
plot3([min(x_val) max(x_val)], [-l -l], [4000 4000],'k'); hold on;
plot3([min(x_val) max(x_val)], [-2*l -2*l], [4000 4000],'k')
% 2 lines showing laser radius
plot3([r_b r_b], [min(z_val) max(z_val)], [4000 4000],'k'); hold on;
plot3([-r_b -r_b], [min(z_val) max(z_val)], [4000 4000],'k')

ax = gca;
ax.Clipping = 'off';

view(0,90) % View directly from above
daspect([1 1 1e8]) % Set unit lengths as equal
colorbar % Show scale bar
caxis([T_0 T_m]) % Set colour limits to be T0 to Tm

if Melt_Properties.max_temp > T_m
    % Find the coordinates of the melt pool
    cont_XZ = cont_XZ(:,2:end);
    Melt_Properties.max_depth = -min(cont_XZ(2,:));
    Melt_Properties.max_depth_position = min(cont_XZ(1,find(cont_XZ(2,:)==min(cont_XZ(2,:)))));
    % Calculate the leading/trailing edge angles (in deg)
    XZ_dz = diff(cont_XZ(2,:));
    XZ_dx = diff(cont_XZ(1,:));
    front = min(find(cont_XZ(1,:)==max(cont_XZ(1,:)))-1);
    Melt_Properties.XZ_theta_front = atand(XZ_dz(front)./XZ_dx(front));
    back = min(find(cont_XZ(1,:)==min(cont_XZ(1,:))));
    Melt_Properties.XZ_theta_back = atand(XZ_dz(back)./XZ_dx(back));
    % Ratio of melt pool in front of/behind max depth
    Melt_Properties.Length_ratio_max_depth = (max(cont_XZ(1,:))-Melt_Properties.max_depth_position)./(Melt_Properties.max_depth_position-min(cont_XZ(1,:)));
    % Area of meltpool
    Melt_Properties.XZ_Area = polyarea(cont_XZ(1,:),cont_XZ(2,:));

    circ = 0;
    for ii = 1:length(XZ_dz)
        circ = circ + sqrt(XZ_dz(ii).^2+XZ_dx(ii).^2);
    end
    Melt_Properties.XZ_roundness = Roundness(2.*Melt_Properties.XZ_Area, 2.*circ);
else % if no melt pool
    Melt_Properties.max_depth = 0;
    Melt_Properties.max_depth_position = 0;
    Melt_Properties.XZ_theta_front = 0;
    Melt_Properties.XZ_theta_back = 0;
    Melt_Properties.Length_ratio_max_depth = 0;
    Melt_Properties.XZ_Area = 0;
    Melt_Properties.XZ_roundness = 0;
end

% Save figure and close
savefig(['E:\Lev\Documents\Rosenthal_Figures\Figures\XZ\XZ_Plot P' num2str(q) ' V' num2str(v) ' .fig'])
saveas(gcf,['E:\Lev\Documents\Rosenthal_Figures\PNGs\XZ\XZ_Plot P' num2str(q) ' V' num2str(v) ' .png'])
close(gcf)
end