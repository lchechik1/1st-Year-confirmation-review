%% CHARACTERISE MELT POOL SHAPE

function Melt_Properties = Melt_Pool_Shape(x_val,y_val,z_val,T_field,T_m)
    %% XY Temperature Field
    T_field_XY = squeeze(T_field(:,:,length(z_val)));
    % Find the coordinates of the melt pool
    cont_XY = contour3(x_val,y_val,T_field_XY,[T_m, T_m]);
    cont_XY = cont_XY(:,2:end);
    % Calculate the maximum width (and its position) and length
    Melt_Properties.max_width = max(cont_XY(2,:))-min(cont_XY(2,:));
    Melt_Properties.max_length = max(cont_XY(1,:))-min(cont_XY(1,:));
    Melt_Properties.max_width_position = cont_XY(1,find(cont_XY(2,:)==max(cont_XY(2,:))));
    % Calculate the leading/trailing edge angles (in deg)
    XY_dy = diff(cont_XY(2,:));
    XY_dx = diff(cont_XY(1,:));
    front = find(cont_XY(1,:)==max(cont_XY(1,:)))-1;
    Melt_Properties.XY_theta_front = atand(XY_dy(front)./XY_dx(front));
    back = find(cont_XY(1,:)==min(cont_XY(1,:)));
    Melt_Properties.XY_theta_back = atand(XY_dy(back)./XY_dx(back));
    % Ratio of melt pool in front of/behind 0
    Melt_Properties.Length_ratio_0 = max(cont_XY(1,:))./-min(cont_XY(1,:));
    % Ratio of melt pool in front of/behind max width
    Melt_Properties.Length_ratio_max_width = (max(cont_XY(1,:))-Melt_Properties.max_width_position)./(Melt_Properties.max_width_position-min(cont_XY(1,:)));
    % Area of meltpool
    Melt_Properties.XY_Area = polyarea(cont_XY(1,:),cont_XY(2,:));
    
    %% XZ Temperature Field
    midpoint = find(y_val==0);
    T_field_XZ = squeeze(T_field(midpoint,:,:));
    % Find the coordinates of the melt pool
    cont_XZ = contour3(x_val,z_val,T_field_XZ.',[T_m, T_m]);
    cont_XZ = cont_XZ(:,2:end);
    Melt_Properties.max_depth = -min(cont_XZ(2,:));
    Melt_Properties.max_depth_position = cont_XZ(1,find(cont_XZ(2,:)==min(cont_XZ(2,:))));
    % Calculate the leading/trailing edge angles (in deg)
    XZ_dy = diff(cont_XZ(2,:));
    XZ_dx = diff(cont_XZ(1,:));
    front = find(cont_XZ(1,:)==max(cont_XZ(1,:)))-1;
    Melt_Properties.XZ_theta_front = atand(XZ_dy(front)./XZ_dx(front));
    back = find(cont_XZ(1,:)==min(cont_XZ(1,:)));
    Melt_Properties.XZ_theta_back = atand(XZ_dy(back)./XZ_dx(back));
    % Ratio of melt pool in front of/behind max depth
    Melt_Properties.Length_ratio_max_depth = (max(cont_XZ(1,:))-Melt_Properties.max_depth_position)./(Melt_Properties.max_depth_position-min(cont_XZ(1,:)));
    % Area of meltpool
    Melt_Properties.XZ_Area = polyarea(cont_XZ(1,:),cont_XZ(2,:));
    
    %% General Properties
    Melt_Properties.max_temp = max(max(max(T_field)));
    %Total volume?
    
    close(gcf)
end