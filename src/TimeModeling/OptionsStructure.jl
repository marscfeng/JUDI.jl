# Options structure 
# Author: Philipp Witte, pwitte@eos.ubc.ca
# Date: May 2017
#

export Options, subsample

# Object for velocity/slowness models
type Options
    space_order::Integer
    retry_n::Integer
    limit_m::Bool
    buffer_size::Real
    save_data_to_disk::Bool
    save_wavefield_to_disk::Bool
    file_path::String
    file_name::String
    sum_padding::Bool
    optimal_checkpointing::Bool
    frequencies::Array
    dft_subsampling_factor::Integer
    isic::Bool
end

"""
    Options
        space_order::Integer
        retry_n::Integer
        limit_m::Bool
        buffer_size::Real
        save_rate::Real
        save_data_to_disk::Bool
        save_wavefield_to_disk::Bool
        file_path::String
        file_name::String
        sum_padding::Bool
        optimal_checkpointing::Bool
        frequencies::Array
        dft_subsampling_factor::Integer
        isic::Bool


Options structure for seismic modeling.

`space_order`: finite difference space order for wave equation (default is 8, needs to be multiple of 4)

`retry_n`: retry modeling operations in case of worker failure up to `retry_n` times

`limit_m`: for 3D modeling, limit modeling domain to area with receivers (saves memory)

`buffer_size`: if `limit_m=true`, define buffer area on each side of modeling domain (in meters)

`save_data_to_disk`: if `true`, saves shot records as separate SEG-Y files

`save_wavefield_to_disk`: If wavefield is return value, save wavefield to disk as pickle file

`file_path`: path to directory where data is saved

`file_name`: shot records will be saved as specified file name plus its source coordinates

`sum_padding`: when removing the padding area of the gradient, sum into boundary rows/columns for true adjoints

`optimal_checkpointing`: instead of saving the forward wavefield, recompute it using optimal checkpointing

`frequencies`: calculate the FWI/LS-RTM gradient in the frequency domain for a given set of frequencies

`dft_subsampling_factor`: compute on-the-fly DFTs on a time axis that is reduced by a given factor (default is 1)

isic`: use linearized inverse scattering imaging condition


Constructor
==========

All arguments are optional keyword arguments with the following default values:

    Options(;retry_n=0, limit_m=false, buffer_size=1e3, save_data_to_disk=false, save_wavefield_to_disk=false, file_path=pwd(), 
            file_name="shot", sum_padding=false, optimal_checkpointing=false, frequencies=[], dft_subsampling_factor=[], isic=false)

"""
Options(;space_order=8,retry_n=0,limit_m=false,buffer_size=1e3, save_data_to_disk=false, save_wavefield_to_disk=false, file_path="", file_name="shot", sum_padding=false, optimal_checkpointing=false, frequencies=[], dft_subsampling_factor=1, isic=false) = 
    Options(space_order,retry_n,limit_m,buffer_size,save_data_to_disk,save_wavefield_to_disk,file_path,file_name, sum_padding, optimal_checkpointing, frequencies, dft_subsampling_factor, isic)


function subsample(options::Options, srcnum)
    if isempty(options.frequencies)
        return options
    else
        opt_out = deepcopy(options)
        opt_out.frequencies = Array{Any}(1)
        opt_out.frequencies[1] = options.frequencies[srcnum]
        return opt_out
    end
end


