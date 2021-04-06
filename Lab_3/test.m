clear all
Pi = 6.020599913;
Gi = -5;
data_final = [];
R = 6870;
for azimuth = 0:360
    for elevation = 0:360
        x = R * cosd(elevation) * cosd(azimuth);
        y = R * cosd(elevation) * sind(azimuth);
        d = sqrt((x).^2 + (y).^2 + (R)^2);
        pfd_coi = Pi + Gi - 10 * log(4 * pi * d);
        data = [azimuth, elevation, pfd_coi].';
        data_final = [data_final data];
    end
end
scatter(data_final(1,:), data_final(2,:), 10, data_final(3,:))

