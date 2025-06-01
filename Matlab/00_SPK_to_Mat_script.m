%% MEA Data Conversion Script
% Convert .spk files to MATLAB format for neural activity analysis
%
% Requirements:
% - Add natsortfiles and AxionFileLoader-main to MATLAB path
% - MEA_convert_spk function must be available
%
% This script:
% 1. Converts .spk files to individual well .mat files
% 2. Combines individual wells into a single plate .mat structure

%% Configuration - Update these paths for your data
% Path to the .spk file to process
file_path = 'path/to/your/recording.spk';

% Directory to save individual well .mat files
output_folder = 'path/to/output/folder';

% Output filename for combined plate .mat file
plate_output_name = 'path/to/plate_output';

% Wells to process (1-48 for standard 48-well plate)
wells_to_process = 1:48;

%% Step 1: Convert .spk to individual well .mat files
fprintf('Converting .spk file to individual well files...\n');
MEA_convert_spk(file_path, output_folder, wells_to_process);

%% Step 2: Combine individual wells into single plate structure
fprintf('Combining wells into plate structure...\n');

% Initialize 6x8 cell array for 48-well plate
Plate = cell(6, 8);

% Get all .mat files in the output folder
mat_files = dir(fullfile(output_folder, '*.mat'));
mat_files = natsortfiles(mat_files);

% Load each well and place in plate structure
for i = 1:48
    % Load the .mat file
    file_path_well = fullfile(output_folder, mat_files(i).name);
    mat_data = load(file_path_well);
    
    % Extract the variable from the structure
    field_names = fieldnames(mat_data);
    variable_data = mat_data.(field_names{1});
    
    % Calculate row and column indices for 6x8 plate
    row = ceil(i / 8);
    col = mod(i - 1, 8) + 1;
    
    % Store in plate structure
    Plate{row, col} = variable_data;
end

% Save combined plate structure
save(plate_output_name, 'Plate', '-v7.3');

fprintf('Conversion complete!\n');
fprintf('Individual wells saved to: %s\n', output_folder);
fprintf('Combined plate saved to: %s\n', plate_output_name);