import numpy as np
import time
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D


mortality_rate_table_male=np.array([
[0,0,0.00474],
[1,0,0.00018],
[2,0,0.00018],
[3,0,0.00018],
[4,0,0.00018],
[5,0,0.00008],
[6,0,0.00008],
[7,0,0.00009],
[8,0,0.00009],
[9,0,0.00009],
[10,0,0.00011],
[11,0,0.00011],
[12,0,0.00011],
[13,0,0.0001],
[14,0,0.0001],
[15,0,0.00033],
[16,0,0.00032],
[17,0,0.00031],
[18,0,0.00032],
[19,0,0.0003],
[20,0.00001,0.00049],
[21,0.00001,0.00048],
[22,0.00001,0.00046],
[23,0.00001,0.00046],
[24,0.00001,0.00047],
[25,0.00002,0.00054],
[26,0.00002,0.00055],
[27,0.00002,0.00054],
[28,0.00002,0.00054],
[29,0.00002,0.00055],
[30,0.00004,0.0007],
[31,0.00004,0.0007],
[32,0.00004,0.00069],
[33,0.00004,0.00069],
[34,0.00004,0.00072],
[35,0.0001,0.00102],
[36,0.0001,0.00103],
[37,0.0001,0.00102],
[38,0.0001,0.001],
[39,0.0001,0.00099],
[40,0.00026,0.00152],
[41,0.00025,0.00146],
[42,0.00024,0.00142],
[43,0.00025,0.00145],
[44,0.00024,0.00142],
[45,0.00043,0.00203],
[46,0.00042,0.00199],
[47,0.00042,0.002],
[48,0.00042,0.00199],
[49,0.00042,0.00201],
[50,0.00072,0.00262],
[51,0.00073,0.00267],
[52,0.00075,0.00277],
[53,0.00079,0.00288],
[54,0.0008,0.00295],
[55,0.00116,0.00422],
[56,0.00121,0.00439],
[57,0.00125,0.00455],
[58,0.0013,0.00473],
[59,0.0013,0.00472],
[60,0.00197,0.00767],
[61,0.00203,0.00791],
[62,0.00202,0.00786],
[63,0.00198,0.00771],
[64,0.00192,0.0075],
[65,0.00266,0.00997],
[66,0.00245,0.00917],
[67,0.00319,0.01194],
[68,0.00329,0.01232],
[69,0.0033,0.01238],
[70,0.00455,0.01635],
[71,0.00513,0.01844],
[72,0.00575,0.02066],
[73,0.00556,0.01997],
[74,0.00564,0.02026],
[75,0.0079,0.02737],
[76,0.00843,0.02918],
[77,0.00898,0.03109],
[78,0.00956,0.03311],
[79,0.01051,0.0364],
[80,0.01436,0.04739],
[81,0.0151,0.04983],
[82,0.01641,0.05418],
[83,0.01825,0.06026],
[84,0.02084,0.0688],
[85,0.02279,0.07418],
[86,0.02568,0.08357],
[87,0.02975,0.09684],
[88,0.03565,0.11603],
[89,0.04302,0.14001],
[90,0.04722,0.15216],
[91,0.05181,0.16517],
[92,0.05684,0.17906],
[93,0.06235,0.19384],
[94,0.06836,0.20951],
[95,0.07494,0.22607],
[96,0.08212,0.24348],
[97,0.08995,0.2617],
[98,0.09848,0.28066],
[99,0.10778,0.30026],
[100,0.1179,0.32038],
[101,0.1289,0.34086],
[102,0.14084,0.36152],
[103,0.15378,0.38212],
[104,0.16779,0.4024],
[105,0.18294,0.42206],
[106,0.19928,0.44076],
[107,0.21688,0.45812],
[108,0.23579,0.47376],
[109,0.25607,0.48726],
[110,0.27775,0.49821],
[111,0.30087,0.50622],
[112,0.32546,0.51091],
[113,0.3515,0.51196],
[114,0.37898,0.50912],
[115,0.40788,0.50224],
[116,0.43811,0.49125],
[117,0.46958,0.47623],
[118,0.50217,0.45734],
[119,0.53571,0.43491],
[120,0.57,0.40935],
[121,0.6048,0.38119],
[122,0.63984,0.35102],
[123,0.6748,0.31948],
[124,0.70936,0.28723],
[125,0.74314,0.25493],
[126,0.77578,0.22318],
[127,0.80692,0.19256],
[128,0.8362,0.16355],
[129,0.86331,0.13658],
[130,0.88798,0.11198],
[131,0.91,0.08998],
[132,0.92926,0.07074],
[133,0.94572,0.05428],
[134,0.95944,0.04056],
[135,0.97056,0.02944],
[136,0.97931,0.02069],
[137,0.98596,0.01404],
[138,0.99084,0.00916],
[139,0.99427,0.00573]
])


mortality_rate_table_female=np.array([
[0,0.00002,0.00377],
[1,0,0.00014],
[2,0,0.00014],
[3,0,0.00015],
[4,0,0.00015],
[5,0,0.00007],
[6,0,0.00008],
[7,0,0.00008],
[8,0,0.00008],
[9,0,0.00008],
[10,0,0.00009],
[11,0,0.00009],
[12,0,0.00008],
[13,0,0.00008],
[14,0,0.00008],
[15,0,0.00015],
[16,0,0.00015],
[17,0,0.00015],
[18,0,0.00015],
[19,0,0.00014],
[20,0.00001,0.00021],
[21,0,0.0002],
[22,0,0.0002],
[23,0,0.0002],
[24,0,0.0002],
[25,0.00001,0.00026],
[26,0.00001,0.00026],
[27,0.00001,0.00026],
[28,0.00001,0.00026],
[29,0.00001,0.00026],
[30,0.00002,0.00039],
[31,0.00002,0.00039],
[32,0.00002,0.00039],
[33,0.00002,0.00038],
[34,0.00002,0.0004],
[35,0.00005,0.00061],
[36,0.00005,0.00062],
[37,0.00005,0.00061],
[38,0.00005,0.0006],
[39,0.00005,0.00058],
[40,0.00008,0.00099],
[41,0.00008,0.00095],
[42,0.00008,0.00091],
[43,0.00008,0.00093],
[44,0.00008,0.00091],
[45,0.00014,0.00149],
[46,0.00013,0.00147],
[47,0.00013,0.00146],
[48,0.00013,0.00146],
[49,0.00013,0.00147],
[50,0.00023,0.00207],
[51,0.00023,0.00212],
[52,0.00024,0.00219],
[53,0.00025,0.00228],
[54,0.00025,0.00234],
[55,0.00041,0.00332],
[56,0.00043,0.00344],
[57,0.00044,0.00357],
[58,0.00046,0.00369],
[59,0.00045,0.00366],
[60,0.00074,0.00567],
[61,0.00076,0.0058],
[62,0.00075,0.00575],
[63,0.00073,0.0056],
[64,0.00072,0.00547],
[65,0.00115,0.0072],
[66,0.00107,0.00665],
[67,0.00137,0.00857],
[68,0.00141,0.00879],
[69,0.00141,0.00882],
[70,0.00218,0.01193],
[71,0.00242,0.01324],
[72,0.00267,0.0146],
[73,0.00257,0.01406],
[74,0.00258,0.01412],
[75,0.00474,0.02073],
[76,0.00497,0.02169],
[77,0.00518,0.02263],
[78,0.00542,0.0237],
[79,0.0058,0.02534],
[80,0.01035,0.03893],
[81,0.01058,0.0398],
[82,0.01101,0.04138],
[83,0.01168,0.04392],
[84,0.01287,0.04837],
[85,0.01854,0.06552],
[86,0.02024,0.07151],
[87,0.02214,0.07824],
[88,0.02474,0.08742],
[89,0.02787,0.09847],
[90,0.03061,0.10745],
[91,0.03362,0.11715],
[92,0.03692,0.12762],
[93,0.04054,0.13888],
[94,0.0445,0.15099],
[95,0.04884,0.16396],
[96,0.05359,0.17782],
[97,0.05879,0.19259],
[98,0.06447,0.20827],
[99,0.07069,0.22485],
[100,0.07748,0.24231],
[101,0.08489,0.26062],
[102,0.09297,0.2797],
[103,0.10178,0.29947],
[104,0.11137,0.31982],
[105,0.1218,0.34059],
[106,0.13313,0.36161],
[107,0.14542,0.38265],
[108,0.15875,0.40347],
[109,0.17317,0.42376],
[110,0.18874,0.4432],
[111,0.20553,0.46142],
[112,0.2236,0.47802],
[113,0.24301,0.49261],
[114,0.26379,0.50476],
[115,0.28599,0.51406],
[116,0.30965,0.52014],
[117,0.33476,0.52265],
[118,0.36133,0.52131],
[119,0.38933,0.51594],
[120,0.41872,0.50644],
[121,0.44942,0.49284],
[122,0.48131,0.47527],
[123,0.51427,0.454],
[124,0.54811,0.42942],
[125,0.58261,0.40201],
[126,0.61753,0.37234],
[127,0.65258,0.34102],
[128,0.68744,0.3087],
[129,0.72175,0.27603],
[130,0.75516,0.24363],
[131,0.7873,0.21208],
[132,0.8178,0.1819],
[133,0.84633,0.15354],
[134,0.87258,0.12737],
[135,0.8963,0.10368],
[136,0.91733,0.08266],
[137,0.93557,0.06443],
[138,0.95102,0.04898],
[139,0.96378,0.03622]
])






































# Number of patients

n_patients=10000;
# Choose whether to calculate for 'male' or 'female'
gender = 'female';

# Default value of 1 below will give calculations for a person with average risk. 2 isdouble risk, 0.5 is half risk, etc.


baseline_CVD_hazard_ratio=0.5;


# Starting age, and effect size, of intervention. For example, a hazard reduction of0.3 means a hazard ratio of 0.7.
# Below the start age, patients never have the intervention. From the start ageonwards, each patient is "run" with one set of chance, twice - once withoutintervention (control) and once with (treated)

hazard_reduction=0.3;
start_age_years= 50;

max_age_years=150;
max_age_days=max_age_years*365;


if gender=='female':
                  mortality_rate_table=mortality_rate_table_male;
elif gender=='female':
                  mortality_rate_table=mortality_rate_table_female;
else:
                  raise Exception('Error: unknown gender')

gen_modulus=2**31
gen_a=1664525
gen_c=1013904223
gen_seed=1



age_years_in_table=mortality_rate_table[:,0]

if not(all(np.diff(age_years_in_table))==1) or min(age_years_in_table)!=0:
                                                                          raise Exception('The first column of the mortality table should be the integers starting from 0 and counting upwards in steps of 1.')



yearly_ihd_mortality_UK_av=mortality_rate_table[:,1]

yearly_nonihd_mortality=mortality_rate_table[:,2]


day=np.array([_ for _ in range(1,max_age_days+1)])

day

year=day/365

year


hazard_ratio_treated = np.ones(np.size(year)) - hazard_reduction*(year>=start_age_years);

hazard_ratio_treated

np.size(year)


row_number_in_mortality_table=np.minimum(np.floor(year).astype('int')+0,np.size(yearly_nonihd_mortality)-1);

daily_ihd_mortality_UK_av=1-(1-yearly_ihd_mortality_UK_av[row_number_in_mortality_table])**(1/365);

stats.describe(yearly_ihd_mortality_UK_av)

daily_ihd_mortality= baseline_CVD_hazard_ratio*daily_ihd_mortality_UK_av;



daily_nonihd_mortality=1-(1-yearly_nonihd_mortality[row_number_in_mortality_table])**(1/365);


p_death_daily_untreated= daily_nonihd_mortality + daily_ihd_mortality;


p_death_daily_treated = daily_nonihd_mortality +daily_ihd_mortality*hazard_ratio_treated;


# Patients are alive to start_age_years

p_death_daily_untreated[0:start_age_years*365]=0;




p_death_daily_treated [0:start_age_years*365]=0;



# Create empty arrays for survival times in the two arms of the simulation



control_life_days = np.NaN*np.ones(n_patients)


treated_life_days = np.NaN*np.ones(n_patients)

start_time = time.time()


for patient in range(0,n_patients):
        one_patients_lifetime_of_dice = np.random.random(max_age_days)
        fatal_dates_untreated = np.nonzero(one_patients_lifetime_of_dice<p_death_daily_untreated);
        if np.size (fatal_dates_untreated)>0:
            control_life_days[patient]=fatal_dates_untreated[0][0] +1;
        else:
            control_life_days[patient]=max_age_days;
        fatal_dates_treated = np.nonzero(one_patients_lifetime_of_dice<p_death_daily_treated);
        if np.size (fatal_dates_treated)>0:
            treated_life_days[patient]=fatal_dates_treated[0][0]+1;
        else:
            treated_life_days[patient]=max_age_days;
        

extra_life_days = treated_life_days - control_life_days;
print(' ')
print('{:g} {:g} year old {:s} patients'.format(n_patients,start_age_years,gender))
print('Cardiovascular event rate = {:g} times standard UKrate'.format(baseline_CVD_hazard_ratio));

print('Proportion not benefitting = {:0.5g}%'.format((1-p_benefitting)*100));
print('Mean extension = {:0.5g} days'.format(np.mean(extra_life_days)));
print('Mean extension for those benefitting = {:0.5g}days'.format(np.mean(extra_life_days)/p_benefitting));
print('Time taken = {:0.5g} seconds'.format(time.time()-start_time));


######Figure

side_3d=31;
area_3d=side_3d**2;
patients_we_will_plot= area_3d;

if n_patients>patients_we_will_plot:
    indices=np.round(np.linspace(n_patients/(patients_we_will_plot*2),n_patients-n_patients/(patients_we_will_plot*2),area_3d))-1
else:
    indices=np.round(np.linspace(1,n_patients,area_3d))-1

indices=indices.astype('int')
    

sorted_extra_life_days=np.sort(extra_life_days);
sample_extra= sorted_extra_life_days[indices];
sample_extra_3d= np.reshape(sample_extra,(side_3d,side_3d));


plt.figure (1)
plt.clf()
plt.subplot(2,2,1)
plt.plot(year,100*(1-(1-p_death_daily_untreated)**365),'r');
plt.plot(year,100*(1-(1-p_death_daily_treated )**365),'g');
plt.axis([0,100,0,20]);
plt.ylabel('Annual mortality (%)')
plt.xlabel('Age (years)')
plt.title('Mortality')
plt.legend('Untreated','Treated');
plt.subplot(2,2,2)
plt.bar( np.arange(0,np.size(extra_life_days)),np.sort(extra_life_days))
plt.subplot(2,2,3)
dezerod_extra_life_days = extra_life_days[extra_life_days !=0];
plt.hist(dezerod_extra_life_days)
plt.xlabel('Days of extra life')
plt.ylabel('Number of patients out of {:g}'.format(n_patients))
