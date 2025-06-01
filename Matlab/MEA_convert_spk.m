function MEA_convert_spk(spk_file, output_folder, wells_to_process)
% MEA_CONVERT_SPK Convert AxionMEA .spk file to individual well .mat files
%
% USAGE:
%   MEA_convert_spk(spk_file, output_folder, wells_to_process)
%
% INPUTS:
%   spk_file         - Path to .spk file to be unpacked
%   output_folder    - Path to output folder for .mat files
%   wells_to_process - Vector of well numbers to convert (e.g., 1:48)
%
% OUTPUTS:
%   Creates individual .mat files for each specified well containing
%   spike time data in a 4x4 cell array (MEA variable)
%
% REQUIREMENTS:
%   - AxionFileLoader toolbox must be in MATLAB path
%   - Sufficient disk space for output files

warning('off');

% Create output folder if it doesn't exist
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
    fprintf('Created output folder: %s\n', output_folder);
end

% Load the .spk file
fprintf('Loading .spk file: %s\n', spk_file);
file = AxisFile(spk_file);

% Set plate configuration
plate_dim = [6, 8];  % Standard 48-well plate
num_channels = 16;   % 16 channels per well (4x4 grid)

% Load all spike data from file
fprintf('Loading spike data from file...\n');
spike_data = file.SpikeData.LoadData;

% Process each well position
fprintf('Converting wells to .mat files...\n');
for row_idx = 1:plate_dim(1)
    for col_idx = 1:plate_dim(2)
        
        % Calculate current well number (1-indexed)
        current_well = (row_idx - 1) * plate_dim(2) + col_idx;
        
        fprintf('Processing Well %d (row %d, col %d)\n', current_well, row_idx, col_idx);
        
        % Check if this well should be processed
        if ismember(current_well, wells_to_process)
            
            % Define output filename
            well_filename = sprintf('well_%d.mat', current_well);
            output_path = fullfile(output_folder, well_filename);
            
            % Skip if file already exists
            if exist(output_path, 'file')
                fprintf('  Well %d already converted, skipping\n', current_well);
                continue;
            end
            
            % Get dimensions of channel array for this well
            channel_dims = size(squeeze(spike_data(row_idx, col_idx, :, :)));
            
            % Initialize MEA cell array for this well
            MEA = cell(channel_dims);
            
            % Extract spike times for each channel
            for channel_row = 1:channel_dims(1)
                for channel_col = 1:channel_dims(2)
                    
                    fprintf('  Extracting channel (%d, %d)\n', channel_row, channel_col);
                    
                    % Get spike data for this channel
                    channel_data = spike_data{row_idx, col_idx, channel_row, channel_col};
                    
                    if ~isempty(channel_data)
                        % Extract spike start times
                        MEA{channel_row, channel_col} = [channel_data(:).Start];
                    else
                        % Empty channel
                        MEA{channel_row, channel_col} = [];
                        fprintf('    Channel (%d, %d) is empty\n', channel_row, channel_col);
                    end
                end
            end
            
            % Save well data to .mat file
            save(output_path, 'MEA', '-v7.3');
            fprintf('  Saved: %s\n', well_filename);
            
        else
            fprintf('  Well %d not in processing list, skipping\n', current_well);
        end
    end
end

fprintf('Conversion complete! Files saved to: %s\n', output_folder);

end