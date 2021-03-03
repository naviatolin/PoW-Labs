image_units = [15, 32, 42, 48, 52, 56, 63]
base_pair = [100, 200, 300, 400, 500, 600, 1000]
p = polyfit(image_units,base_pair,3);
x1 = linspace(0,4*pi);
y1 = polyval(p, 33.2);
y2 = polyval(p, 41);
y3 = polyval(p, 45.2);
y4 = polyval(p, 48);
y5 = polyval(p, 52.6);
y6 = polyval(p, 55.8);
y1 * 617.96 + 36.04
y6 * 617.96 + 36.04