

# This code is based on CEEM's Nemosis tool
# For a full description of how Nemosis works see https://github.com/UNSW-CEEM/NEMOSIS

from nemosis import data_fetch_methods
import pandas as pd

# Set the days for which the cleaned files will be generated
timeData = pd.date_range(start='2018/01/31', periods=(2), freq='d')     # Periods controls number of days

start_time_array = timeData[0:-1]
end_time_array = timeData[1:len(timeData)]


# For every day this creates a clean csv file of the Gen and Load of HPR
for x in range(0,len(start_time_array)):
    print(x)
    start_time = start_time_array[x].strftime("%Y/%m/%d %H:%M:%S")
    print(start_time)
    end_time = end_time_array[x].strftime("%Y/%m/%d %H:%M:%S")
    print(end_time)
    table = 'FCAS_4_SECOND'
    raw_data_cache = 'C:/...'                                           # The folder where the raw data is stored

    gen_filename = 'C:/.../HRP_GEN_TEST##.csv'                          # The folder where the cleaned data will go
    load_filename = 'C:/.../HRP_LOAD_TEST##.csv'                        # The folder where the cleaned data will go
    gen_filename = gen_filename.replace('##',start_time_array[x].strftime("%Y%m%d"))
    load_filename = load_filename.replace('##',start_time_array[x].strftime("%Y%m%d"))

    price_data = data_fetch_methods.dynamic_data_compiler(start_time, end_time, table, raw_data_cache)


    price_data_HPRGen = price_data[price_data.ELEMENTNUMBER.isin(['330']) & price_data.VARIABLENUMBER.isin(['2'])]
    price_data_HPRLoad = price_data[price_data.ELEMENTNUMBER.isin(['331']) & price_data.VARIABLENUMBER.isin(['2'])]

    price_data_HPRGen.sort_values(by=['TIMESTAMP']).to_csv(gen_filename)
    price_data_HPRLoad.sort_values(by=['TIMESTAMP']).to_csv(load_filename)
