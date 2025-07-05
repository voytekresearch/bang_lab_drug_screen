# Neural Activity Analysis Pipeline for Multi-Electrode Array (MEA) Data (Collaboration with Bang Lab)

Analysis pipeline for processing and analyzing neural activity from Multi-Electrode Array recordings, with a focus on spike train analysis, oscillatory burst detection, and spectral parameterization.

## Disclaimer: Code readability and commenting was AI assisted (Claude Sonnet 4)

## Pipeline Workflow

```
Raw MEA Data (.spk) 
    ↓ MATLAB
Individual Well Files (.mat)
    ↓ MATLAB  
Combined Plate Structure (.mat)
    ↓ Python
Spike Train Processing (JSON)
    ↓ Python
Spectral Analysis (Pickle)
    ↓ Python
Burst Analysis & Results (CSV)
```

## Installation

### MATLAB Requirements

1. **AxionFileLoader Toolbox**
   - Add to MATLAB path

2. **natsortfiles Function**
   - Download from MATLAB File Exchange
   - Used for natural sorting of filenames

### Python Requirements

Install dependencies using pip, or create the environment from .yml:

```bash
conda create --name environment_NDD.yml
```

## File Organization

```
your_project/
├── matlab/
│   ├── mea_data_conversion_script.m
│   └── MEA_convert_spk.m
├── python/
│   ├── plate_processor.py
│   ├── spectral_analyzer.py
│   └── oscillatory_burst_analyzer.py
├── environment_NDD.yml
├── README.md
└── data/
    ├── raw_recordings/          # .spk files
    ├── processed_plates/        # .mat files
    ├── spike_data/             # JSON files
    ├── spectral_analysis/      # Pickle files
    └── burst_analysis/         # CSV results
```

## License

In progress

