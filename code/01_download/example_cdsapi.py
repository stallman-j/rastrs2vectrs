import cdsapi

c = cdsapi.Client()

c.retrieve(
    'reanalysis-era5-single-levels',
    {
        'product_type': 'reanalysis',
        'format': 'netcdf',
        'variable': [
            'sea_surface_temperature', 'surface_pressure', 'total_precipitation',
        ],
        'year': '1994',
        'month': '09',
        'day': [
            '01', '02',
        ],
        'time': [
            '00:00', '01:00',
        ],
    },
    'download.nc')
