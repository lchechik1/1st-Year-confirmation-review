%% PLOT X-Z TEMPERATURE FIELD - GAUMANN

function Melt_Properties = Plot_T_field_X_Y(x_val,y_val,z_val,T_field,T_0,T_m,r_b,q,v,k)

% Create a new figure (full screen)
figure('units','normalized','outerposition',[0 0 1 1])

% Create X-Y grid
[X,Y] = meshgrid(x_val,y_val);

% Plot X-Y surface
T_field_plot = squeeze(T_field(:,:,length(z_val)));
surf(X, Y, T_field_plot,'EdgeColor','none'); hold on;

% Add black line to show melt pool boundary
cont_XY = contour3(x_val,y_val,T_field_plot,[T_m, T_m], 'black');

% 2 lines showing laser radius
plot3([r_b r_b], [min(y_val) max(y_val)], [297 297],'k'); hold on;
plot3([-r_b -r_b], [min(y_val) max(y_val)], [297 297],'k')

view(0,270) % View directly from above
daspect([1 1 1e8]) % Set unit lengths as equal
colorbar % Show scale bar
caxis([T_0 T_m]) % Set colour limits to be T0 to Tm

Melt_Properties.max_temp = max(max(max(T_field)));
if Melt_Properties.max_temp > T_m
    % Find the coordinates of the melt pool
    cont_XY = cont_XY(:,2:end);
    % Calculate the maximum width (and its position) and length
    Melt_Properties.max_width = max(cont_XY(2,:))-min(cont_XY(2,:));
    Melt_Properties.max_length = max(cont_XY(1,:))-min(cont_XY(1,:));
    Melt_Properties.max_width_position = min(cont_XY(1,find(cont_XY(2,:)==max(cont_XY(2,:)))));
    % Calculate the leading/trailing edge angles (in deg)
    XY_dy = diff(cont_XY(2,:));
    XY_dx = diff(cont_XY(1,:));
    % min, in case array returned
    front = min(find(cont_XY(1,:)==max(cont_XY(1,:)))-1);
    Melt_Properties.XY_theta_front = atand(XY_dy(front)./XY_dx(front));
    back = min(find(cont_XY(1,:)==min(cont_XY(1,:))));
    Melt_Properties.XY_theta_back = atand(XY_dy(back)./XY_dx(back));
    % Ratio of melt pool in front of/behind 0
    Melt_Properties.Length_ratio_0 = max(cont_XY(1,:))./-min(cont_XY(1,:));
    % Ratio of melt pool in front of/behind max width
    Melt_Properties.Length_ratio_max_width = (max(cont_XY(1,:))-Melt_Properties.max_width_position)./(Melt_Properties.max_width_position-min(cont_XY(1,:)));
    % Area of meltpool
    Melt_Properties.XY_Area = polyarea(cont_XY(1,:),cont_XY(2,:));
    % Thermal gradient at end of meltpool at t=1e-6; dT of one point either
    % side
	y_axis = squeeze(T_field_plot(find(y_val==0),:));
    mp_end = min(find(y_axis>T_m));
    dT = y_axis(mp_end)-y_axis(mp_end-1);
    dx = x_val(2)-x_val(1);
%     t=1e-6;
    
%     Melt_Properties.cooling_rate = -4.*dT.*(min(cont_XY(1,:))+v.*t)./((2.*r_b).^2+8.*a.*t);
%     Melt_Properties.cooling_rate = CR_x(mp_end);
    Melt_Properties.Thermal_gradient = dT/dx;
    Melt_Properties.cooling_rate = 2.*pi.*k.*v.*((y_axis(mp_end)-T_0).^2)./q;

    circ = 0;
    for ii = 1:length(XY_dy)
        circ = circ + sqrt(XY_dy(ii).^2+XY_dx(ii).^2);
    end
    Melt_Properties.XY_roundness = Roundness(Melt_Properties.XY_Area, circ);
else % if no melt pool
    Melt_Properties.max_width = 0;
    Melt_Properties.max_length = 0;
    Melt_Properties.max_width_position = 0;
    Melt_Properties.XY_theta_front = 0;
    Melt_Properties.XY_theta_back = 0;
    Melt_Properties.Length_ratio_0 = 0;
    Melt_Properties.Length_ratio_max_width = 0;
    Melt_Properties.XY_Area = 0;
    Melt_Properties.XY_roundness = 0;
    Melt_Properties.Thermal_gradient = 0;
    Melt_Properties.cooling_rate = 0;
end


% Save figure and close
savefig(['E:\Lev\Documents\Rosenthal_Figures\Figures\XY\XY_Plot P' num2str(q) ' V' num2str(v) ' .fig'])
saveas(gcf,['E:\Lev\Documents\Rosenthal_Figures\PNGs\XY\XY_Plot P' num2str(q) ' V' num2str(v) ' .png'])
close(gcf)
end