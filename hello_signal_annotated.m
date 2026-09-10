%% 生成带“主峰 / 泄漏裙边”标注的功率谱图
fs = 8000;
t = 0:1/fs:1;
x = sin(2*pi*1000*t);

[Pxx, f] = pwelch(x, [], [], [], fs);
db = 10*log10(Pxx);          % 转成 dB

[ypk, ipk] = max(db);        % 找到主峰
fpk = f(ipk);                % 主峰频率（应为 1000 Hz）
fprintf('主峰频率 = %.1f Hz\n', fpk);

%% 让图中的中文用微软雅黑显示（避免方框）
set(0, 'DefaultAxesFontName', 'Microsoft YaHei');

%% 左图：全频段，标出主峰
figure('Color', 'w', 'Position', [80 80 1150 480]);

subplot(1, 2, 1);
plot(f, db, 'LineWidth', 1.2, 'Color', [0 0.45 0.74]);
xlim([0 4000]); grid on;
xlabel('频率 (Hz)'); ylabel('功率谱密度 (dB)');
title('全频段：1000 Hz 主峰');
hold on;
plot(fpk, ypk, 'rv', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
text(fpk + 120, ypk - 30, '主峰 1000 Hz', ...
    'FontName', 'Microsoft YaHei', 'Color', 'r', 'FontSize', 11);
hold off;

%% 右图：放大到 850~1150 Hz，标出泄漏裙边范围
% 裙边范围取“比主峰低 60 dB 以内的左右边界”
th = ypk - 60;
iL = find(f > fpk - 200 & f < fpk & db > th, 1, 'last');
iR = find(f > fpk & f < fpk + 200 & db > th, 1, 'first');
xL = f(iL);
xR = f(iR);
fprintf('泄漏裙边范围 ≈ %.1f ~ %.1f Hz\n', xL, xR);

subplot(1, 2, 2);
ymin = floor(min(db(f > 850 & f < 1150)) / 10) * 10;
ymax = ceil(ypk / 10) * 10 + 10;
plot(f, db, 'LineWidth', 1.2, 'Color', [0 0.45 0.74]);
xlim([850 1150]); ylim([ymin ymax]); grid on;
xlabel('频率 (Hz)'); ylabel('功率谱密度 (dB)');
title('放大：主峰底部的“裙边”（谱泄漏）');
hold on;

% 橙色半透明带：裙边范围
yl = ylim;
patch([xL xR xR xL], [yl(1) yl(1) yl(2) yl(2)], ...
      [1 0.6 0.1], 'FaceAlpha', 0.15, 'EdgeColor', 'none');
plot(f, db, 'LineWidth', 1.5, 'Color', [0 0.45 0.74]);  % 重新画曲线，避免被色带盖住

% 主峰竖线与标记
line([fpk fpk], ylim, 'Color', 'r', 'LineStyle', '--', 'LineWidth', 1);
plot(fpk, ypk, 'rv', 'MarkerSize', 11, 'MarkerFaceColor', 'r');

% 裙边左右边界虚线
line([xL xL], ylim, 'Color', [1 0.6 0.1], 'LineStyle', ':', 'LineWidth', 1.5);
line([xR xR], ylim, 'Color', [1 0.6 0.1], 'LineStyle', ':', 'LineWidth', 1.5);

% 文字标注
text(fpk + 8, ypk - 12, '主峰', ...
    'FontName', 'Microsoft YaHei', 'Color', 'r', 'FontSize', 12);
text(xL - 4, yl(1) + (yl(2) - yl(1)) * 0.25, ...
    sprintf('裙边左界 ≈ %.0f Hz', xL), ...
    'FontName', 'Microsoft YaHei', 'Color', [0.7 0.4 0], 'FontSize', 10);
text(xR - 80, yl(1) + (yl(2) - yl(1)) * 0.15, ...
    sprintf('裙边右界 ≈ %.0f Hz', xR), ...
    'FontName', 'Microsoft YaHei', 'Color', [0.7 0.4 0], 'FontSize', 10);
hold off;

%% 可选：把图保存成 PNG
% exportgraphics(gcf, 'D:\ResearchData\future\hello_signal_leakage_annotated_matlab.png', 'Resolution', 150);