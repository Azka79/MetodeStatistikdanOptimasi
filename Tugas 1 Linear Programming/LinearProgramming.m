%% ========================================================================
%  OPTIMASI LINEAR PROGRAMMING - WYNDOR GLASS CO. PROBLEM
%  Berdasarkan: Hillier & Lieberman, Chapter 3, Section 3.1
%  Metode: Simplex Method (via MATLAB linprog)
%  Tujuan: Maksimasi Profit dari Produksi 2 Produk Baru
%% ========================================================================

clear; clc; close all;

%% 1. DESKRIPSI MASALAH
fprintf('========================================================================\n');
fprintf('           WYNDOR GLASS CO. - LINEAR PROGRAMMING PROBLEM\n');
fprintf('========================================================================\n\n');

fprintf('DESKRIPSI MASALAH:\n');
fprintf('Wyndor Glass Co. akan meluncurkan 2 produk baru:\n');
fprintf('  - Product 1: Pintu kaca 8-kaki dengan bingkai aluminium\n');
fprintf('  - Product 2: Jendela kayu 4x6 kaki double-hung\n\n');

fprintf('TUJUAN:\n');
fprintf('Memaksimalkan total profit dengan keterbatasan kapasitas 3 plants\n\n');

fprintf('MODEL LINEAR PROGRAMMING:\n');
fprintf('  Maximize Z = 3x1 + 5x2  (dalam ribuan dolar)\n\n');
fprintf('  Subject to:\n');
fprintf('    x1           <= 4   (Plant 1: Bingkai Aluminium)\n');
fprintf('         2x2     <= 12  (Plant 2: Bingkai Kayu)\n');
fprintf('    3x1 + 2x2    <= 18  (Plant 3: Kaca & Perakitan)\n');
fprintf('    x1, x2       >= 0   (Non-negativity)\n\n');

fprintf('di mana:\n');
fprintf('  x1 = jumlah batch Product 1 per minggu\n');
fprintf('  x2 = jumlah batch Product 2 per minggu\n');
fprintf('  (1 batch = 20 unit)\n\n');

%% 2. PARAMETER LINEAR PROGRAMMING

% Vektor koefisien fungsi objektif (untuk minimisasi -Z)
% Karena linprog melakukan MINIMISASI, kita ubah terlebih dahulu dengan mengalikan fungsi dengan -1:
% Maximize Z = 3x1 + 5x2  menjadi  Minimize -Z = -3x1 - 5x2
f = [-3; -5];

% Matriks koefisien constraint inequality (A*x <= b)
% Baris 1: Plant 1 constraint (1x1 + 0x2 <= 4)
% Baris 2: Plant 2 constraint (0x1 + 2x2 <= 12)
% Baris 3: Plant 3 constraint (3x1 + 2x2 <= 18)
A = [1  0;      % Plant 1
     0  2;      % Plant 2
     3  2];     % Plant 3

% Vektor ruas kanan constraint inequality
% Kapasitas waktu produksi tersedia (dalam jam per minggu)
b = [4;         % Plant 1: 4 jam
     12;        % Plant 2: 12 jam
     18];       % Plant 3: 18 jam

% Constraint equality (tidak ada dalam masalah ini)
Aeq = [];
beq = [];

% Batas bawah variabel (non-negativity constraints)
lb = [0; 0];    % x1 >= 0, x2 >= 0

% Batas atas variabel (tidak ada batas atas eksplisit)
ub = [];        % Default: [Inf; Inf]

%% 3. PENGATURAN ALGORITMA

% Opsi untuk linprog
% Algorithm options: 'interior-point', 'dual-simplex', 'active-set'
options = optimoptions('linprog', ...
    'Algorithm', 'dual-simplex', ...    % Menggunakan Dual-Simplex Method
    'Display', 'iter');                  % Menampilkan iterasi

%% 4. PENYELESAIAN MENGGUNAKAN LINPROG

fprintf('------------------------------------------------------------------------\n');
fprintf('MENYELESAIKAN MASALAH MENGGUNAKAN LINPROG (DUAL-SIMPLEX METHOD)...\n');
fprintf('------------------------------------------------------------------------\n\n');

% Memanggil fungsi linprog
% Syntax: [x, fval, exitflag, output, lambda] = linprog(f, A, b, Aeq, beq, lb, ub, options)
[x_optimal, fval, exitflag, output, lambda] = linprog(f, A, b, Aeq, beq, lb, ub, options);

%% 5. MENAMPILKAN HASIL OPTIMASI

fprintf('\n========================================================================\n');
fprintf('                         HASIL OPTIMASI\n');
fprintf('========================================================================\n\n');

if exitflag == 1
    % Solusi optimal ditemukan
    fprintf('STATUS: ✓ OPTIMAL SOLUTION FOUND\n\n');
    
    % Nilai optimal variabel keputusan
    fprintf('VARIABEL KEPUTUSAN OPTIMAL:\n');
    fprintf('  x1* (Product 1: Pintu Kaca)     = %.4f batch/minggu\n', x_optimal(1));
    fprintf('  x2* (Product 2: Jendela Kayu)   = %.4f batch/minggu\n\n', x_optimal(2));
    
    fprintf('INTERPRETASI:\n');
    fprintf('  Product 1: %.0f batch × 20 unit/batch = %.0f unit/minggu\n', ...
        x_optimal(1), x_optimal(1)*20);
    fprintf('  Product 2: %.0f batch × 20 unit/batch = %.0f unit/minggu\n\n', ...
        x_optimal(2), x_optimal(2)*20);
    
    % Nilai optimal fungsi objektif
    % Karena kita minimisasi -Z, maka Z_optimal = -fval
    Z_optimal = -fval;
    
    fprintf('NILAI FUNGSI OBJEKTIF OPTIMAL:\n');
    fprintf('  Z* = %.4f (dalam ribuan dolar)\n', Z_optimal);
    fprintf('  Z* = $%.2f per minggu\n\n', Z_optimal * 1000);
    
    % Proyeksi profit
    profit_per_year = Z_optimal * 1000 * 52;  % 52 minggu dalam setahun
    fprintf('PROYEKSI PROFIT:\n');
    fprintf('  Profit per minggu  : $%.2f\n', Z_optimal * 1000);
    fprintf('  Profit per tahun   : $%.2f\n\n', profit_per_year);
    
    % Informasi algoritma
    fprintf('INFORMASI ALGORITMA:\n');
    fprintf('  Algoritma          : %s\n', output.algorithm);
    fprintf('  Jumlah Iterasi     : %d\n', output.iterations);
    fprintf('  Pesan              : %s\n\n', output.message);
    
else
    % Tidak ditemukan solusi optimal
    fprintf('STATUS: ✗ SOLUSI OPTIMAL TIDAK DITEMUKAN\n');
    fprintf('Exit Flag: %d\n', exitflag);
    fprintf('Pesan: %s\n', output.message);
    return;  % Hentikan program
end

%% 6. VERIFIKASI DAN ANALISIS CONSTRAINT

fprintf('========================================================================\n');
fprintf('                    VERIFIKASI CONSTRAINT\n');
fprintf('========================================================================\n\n');

% Evaluasi nilai constraint (A*x)
constraint_values = A * x_optimal;

% Nama constraint untuk display
constraint_names = {'Plant 1 (Aluminium)', 'Plant 2 (Kayu)', 'Plant 3 (Kaca)'};

fprintf('%-25s | Terpakai | Tersedia | Slack | Status\n', 'Constraint');
fprintf('--------------------------------------------------------------------------\n');

% Slack variables
slack = b - constraint_values;

% Toleransi untuk menentukan binding constraint
tolerance = 1e-6;

for i = 1:length(b)
    % Tentukan status constraint
    if constraint_values(i) > b(i) + tolerance
        status = '✗ VIOLATED';
    elseif abs(constraint_values(i) - b(i)) < tolerance
        status = '⚠ BINDING';
    else
        status = '✓ OK';
    end
    
    fprintf('%-25s | %8.4f | %8.2f | %5.2f | %s\n', ...
        constraint_names{i}, constraint_values(i), b(i), slack(i), status);
end

fprintf('\n');

% Interpretasi Slack Variables
fprintf('INTERPRETASI SLACK VARIABLES:\n');
fprintf('  Slack = Kapasitas yang TIDAK terpakai\n\n');

for i = 1:length(slack)
    if abs(slack(i)) < tolerance
        fprintf('  %s: %.2f jam → FULLY UTILIZED (Bottleneck)\n', ...
            constraint_names{i}, slack(i));
    else
        fprintf('  %s: %.2f jam → Masih ada kapasitas tersisa\n', ...
            constraint_names{i}, slack(i));
    end
end

%% 7. VISUALISASI GRAFIS (GRAPHICAL METHOD)

fprintf('\n========================================================================\n');
fprintf('                      VISUALISASI GRAFIS\n');
fprintf('========================================================================\n\n');

fprintf('Membuat grafik feasible region dan solusi optimal...\n\n');

% Buat figure
figure('Name', 'Wyndor Glass Co. - Graphical Solution', 'NumberTitle', 'off', ...
       'Position', [100, 100, 900, 700]);

% Rentang nilai untuk plotting
x1_max = 8;  % Batas plotting untuk x1
x2_max = 10; % Batas plotting untuk x2
x1_range = 0:0.1:x1_max;

hold on; grid on; box on;

%% Gambar garis constraint

% Constraint 1: x1 = 4 (garis vertikal)
line([4, 4], [0, x2_max], 'Color', 'r', 'LineWidth', 1.5, ...
     'DisplayName', 'C1: x_1 = 4 (Plant 1)');

% Constraint 2: 2x2 = 12, atau x2 = 6 (garis horizontal)
line([0, x1_max], [6, 6], 'Color', 'b', 'LineWidth', 1.5, ...
     'DisplayName', 'C2: 2x_2 = 12 (Plant 2)');

% Constraint 3: 3x1 + 2x2 = 18
x2_c3 = (18 - 3*x1_range) / 2;
plot(x1_range, x2_c3, 'g-', 'LineWidth', 1.5, ...
     'DisplayName', 'C3: 3x_1 + 2x_2 = 18 (Plant 3)');

%% Gambar feasible region (shaded area)

% Corner points dari feasible region (sesuai dengan analisis grafis)
% Urutan: (0,0) → (4,0) → (4,3) → (2,6) → (0,6) → (0,0)
feasible_x = [0; 4; 4; 2; 0; 0];
feasible_y = [0; 0; 3; 6; 6; 0];

fill(feasible_x, feasible_y, [0.4 0.4 0.4], 'FaceAlpha', 0.6, ...
     'EdgeColor', 'k', 'LineWidth', 1.2, 'DisplayName', 'Feasible Region');

%% Plot corner points
corner_x = [0; 4; 4; 2; 0];
corner_y = [0; 0; 3; 6; 6];

plot(corner_x, corner_y, 'ko', 'MarkerSize', 10, 'MarkerFaceColor', 'yellow', ...
     'DisplayName', 'Corner Point Feasible (CPF)');

% Label untuk setiap corner point dengan nilai Z
corner_labels = {
    sprintf('(0,0)\nZ=%.0f', 3*0 + 5*0);
    sprintf('(4,0)\nZ=%.0f', 3*4 + 5*0);
    sprintf('(4,3)\nZ=%.0f', 3*4 + 5*3);
    sprintf('(2,6)\nZ=%.0f', 3*2 + 5*6);
    sprintf('(0,6)\nZ=%.0f', 3*0 + 5*6)
};

offset_x = [0.3; 0.3; 0.3; -0.6; -0.6];
offset_y = [-0.5; -0.5; 0.3; 0.3; 0.3];

for i = 1:length(corner_x)
    text(corner_x(i) + offset_x(i), corner_y(i) + offset_y(i), ...
         corner_labels{i}, 'FontSize', 9, 'FontWeight', 'bold', ...
         'HorizontalAlignment', 'left');
end

%% Plot optimal solution dengan penanda khusus
plot(x_optimal(1), x_optimal(2), 'r*', 'MarkerSize', 20, 'LineWidth', 3, ...
     'DisplayName', sprintf('Optimal Solution (%.0f, %.0f)', x_optimal(1), x_optimal(2)));

%% Gambar iso-profit line melalui solusi optimal
% Z = 3x1 + 5x2 = 36
% x2 = (36 - 3x1)/5
Z_opt = -fval;
x2_isoprofit = (Z_opt - 3*x1_range) / 5;
plot(x1_range, x2_isoprofit, 'm--', 'LineWidth', 2.5, ...
     'DisplayName', sprintf('Iso-Profit: Z = %.0f', Z_opt));

% Gambar beberapa iso-profit line lain untuk ilustrasi
Z_values = [10, 20, 30];
for Z_val = Z_values
    x2_iso = (Z_val - 3*x1_range) / 5;
    plot(x1_range, x2_iso, 'm:', 'LineWidth', 1, 'HandleVisibility', 'off');
end

% Label untuk iso-profit lines
text(7, (10 - 3*7)/5, 'Z=10', 'FontSize', 8, 'Color', 'm');
text(7, (20 - 3*7)/5, 'Z=20', 'FontSize', 8, 'Color', 'm');
text(7, (30 - 3*7)/5, 'Z=30', 'FontSize', 8, 'Color', 'm');

%% Anotasi untuk solusi optimal
annotation_text = sprintf('OPTIMAL SOLUTION\nx₁* = %.0f batch\nx₂* = %.0f batch\nZ* = $%.0f/week', ...
    x_optimal(1), x_optimal(2), Z_opt * 1000);

text(x_optimal(1) + 0.5, x_optimal(2) - 0.8, annotation_text, ...
     'FontSize', 11, 'FontWeight', 'bold', 'BackgroundColor', 'white', ...
     'EdgeColor', 'red', 'LineWidth', 1.5);

%% Formatting grafik
xlabel('x_1 (Batch Product 1 per minggu)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('x_2 (Batch Product 2 per minggu)', 'FontSize', 12, 'FontWeight', 'bold');
title({'WYNDOR GLASS CO. - GRAPHICAL SOLUTION METHOD', ...
       'Maximize Z = 3x_1 + 5x_2 subject to resource constraints'}, ...
      'FontSize', 14, 'FontWeight', 'bold');

legend('Location', 'northeast', 'FontSize', 10);
xlim([0 x1_max]);
ylim([0 x2_max]);
set(gca, 'FontSize', 11);

% Grid minor untuk precision
grid minor;

hold off;

%% 8. TABEL PERBANDINGAN SEMUA CORNER POINTS

fprintf('========================================================================\n');
fprintf('         EVALUASI SEMUA CORNER POINT FEASIBLE (CPF) SOLUTIONS\n');
fprintf('========================================================================\n\n');

fprintf('%-6s | %-8s | %-8s | %-12s | %-10s\n', 'CPF', 'x1', 'x2', 'Z = 3x1+5x2', 'Status');
fprintf('--------------------------------------------------------------------------\n');

cpf_data = [
    0, 0;
    4, 0;
    4, 3;
    2, 6;
    0, 6
];

for i = 1:size(cpf_data, 1)
    x1_cpf = cpf_data(i, 1);
    x2_cpf = cpf_data(i, 2);
    Z_cpf = 3*x1_cpf + 5*x2_cpf;
    
    if abs(x1_cpf - x_optimal(1)) < tolerance && abs(x2_cpf - x_optimal(2)) < tolerance
        status = '★ OPTIMAL';
    else
        status = '';
    end
    
    fprintf('%-6d | %8.2f | %8.2f | %12.2f | %-10s\n', ...
        i, x1_cpf, x2_cpf, Z_cpf, status);
end

fprintf('\n');

fprintf('========================================================================\n');
fprintf('                     PROGRAM SELESAI\n');
fprintf('========================================================================\n');