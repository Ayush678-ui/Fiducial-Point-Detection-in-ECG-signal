clc;
clear;
close all;
% Load ECG data from CSV file
ecg_data = readtable('ecg.csv');
ecg_signal = ecg_data{:, 1}; % Assuming the ECG signal is in the first column

% Preprocessing: Bandpass filter to remove noise
fs = 1000; % Sampling frequency (adjust according to your data)
low_cutoff = 0.5; % Low cutoff frequency (Hz)
high_cutoff = 50; % High cutoff frequency (Hz)

% Design a bandpass filter
[b, a] = butter(4, [low_cutoff, high_cutoff] / (fs / 2), 'bandpass');
filtered_ecg = filtfilt(b, a, ecg_signal);

% Parameters for R-peak detection
threshold = 0.6; % Adjust based on your data
min_distance = 250; % Minimum distance between peaks (adjust based on sampling rate)

% Find R-peaks using findpeaks function
[peaks, locs] = findpeaks(filtered_ecg, 'MinPeakHeight', threshold, 'MinPeakDistance', min_distance);

% Plot the original and filtered ECG signal, and detected peaks
figure;
subplot(2, 1, 1);
plot(ecg_signal);
title('Original ECG Signal');
xlabel('Samples');
ylabel('Amplitude');

subplot(2, 1, 2);
plot(filtered_ecg);
hold on;
plot(locs, peaks, 'rx', 'MarkerSize', 10); % Mark detected R-peaks
title('Filtered ECG Signal with Detected R-peaks');
xlabel('Samples');
ylabel('Amplitude');
legend('Filtered ECG Signal', 'Detected R-peaks');
hold off;

% Display detected fiducial points (R-peaks)
disp('Detected R-peaks at indices:');
disp(locs);
