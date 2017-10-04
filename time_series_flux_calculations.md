Untitled
================
François Birgand
4 October 2017

Stream flow - instantaneous or mean over an interval - Why should we care?
==========================================================================

### François Birgand, Associate Professor, NC State University

------------------------------------------------------------------------

Hydrological Time Series and Flux Calculations
----------------------------------------------

------------------------------------------------------------------------

There is an interesting observation we should all keep in mind when we calculate cumulative values in time series. In hydrology, we often calculate water and nutrient fluxes. We inherit files of data with two columns: one with the dates, one with the 'flow data'. It may be very tempting to just add the values together (like one does with precipitation data) and multiply that sum by the time resolution and voilà... no big deal! However, it is not that simple and in most cases this simple reasoning may actually be false...! Really? How can that be??? The answer: one must keep a close eye on what 'flow data' exactly one is dealing with.

### Precipitation data is always reported as cumulative values over a time interval

Because this is the easy way to measure rainfall, precipitation data is always reported as the cumulative precipitation over a given period, and the time stamp associated with each value corresponds to the end of the interval. In other words, if you inherit an *hourly precipitation* file where on a file row the time stamp is 2010-10-15 01:00 and the precipitation value is 5 mm, it means that it rained a *cumulative* rainfall depth of 5 mm *between* 2010-10-15 00:00 and 2010-10-15 01:00.
So to calculate the total precipitation over a given period, one only needs to add all the values reported in a particular file. Simple. The dimension of precipitation data are \[*L*\], or length, i.e., the depth of rain over a given area. In reality, it really corresponds to a volume of water \[*L*<sup>3</sup>\], or volume, that fell over a given land area. But this is beside the point.

### Flow volumes

Contrary to precipitation data, the easiest way to measure flow is not by measuring flow volumes, but to measure (actually calculate from measured stage and/or velocity) *flow rates*, which dimensions are \[*L*<sup>3</sup>.*T*<sup>−1</sup>\] or volume per time. This is the reason why flow data are almost always reported as flow rates. So adding flow rate values from a file will not yield volumes, but a number in the same \[*L*<sup>3</sup>.*T*<sup>−1</sup>\] dimension. One must then multiply by the time interval between each flow values reported to calculate the volume because \[*L*<sup>3</sup>.*T*<sup>−1</sup>\].\[*T*\] yields \[*L*<sup>3</sup>\]. HOWEVER, and this is where it can be quite confusing, it turns out that flow rates values can be reported in two ways and correspond to two different types of values...!
\*\** \#\# Instantaneous vs. mean discharge over an interval There are two ways to report discharge data: for a given time stamp, the discharge value may correspond to either: * the *instantaneous* discharge value OR \* the *mean discharge* over the time resolution interval prior to the time stamp

So why did hydrologists complicate things this much, really...? There are some good reasons for this. But does it matter? For big rivers which flow rates do not vary very rapidly, it is not rare to have daily flow values reported. This means that for a given flow value, there is no time of the day associated with the time stamp, just the date. This is often a good hint that the values correspond to *mean daily discharges* (see below on how they are calculated). Still, if instruments can meaure stage or velocity at a given instant, why not report these instead?

Actually, in hydrology, absolutely instantaneous meaurements essentially do not exist *stricto sensu*. First, this is because every sensor needs a little bit of time to make its meaurements, might it be several milliseconds. Second, in many cases it is advantageous to measure over a given (often short period like 30 sec) stage or velocity many times and average measurements over these 30 sec, and consider that the 30-sec average does correspond to the 'instantaneous' value for the discharge. Indeed, because of waves, turbulence, instrument instabilities, etc. there can be a bit of noise in the meaurements, and it might be advantageous to average them. In most streams and rivers, flow does not change quickly enough to make a significant difference over e.g., 30 sec.

However, some instruments do offer the possibility to report for a given time stamp the average of *n* measurements regularly spaced over a time interval and assign the time stamp corresponding to the end of that interval. The same instruments could also report the measurement they can make in a split second, i.e., almost instantaneously. So with the same instrument and for a given time stamp (and in this case there would be a time of day, so there would be no hint that the values would correspond to interval means) the 'flow rates' reported could correspond to in fact rather different values... So theoretically one should know exactly on what setting the instrument was set on.

But does it really matter? We shall see below, that indeed, there is space for errors when calculating cumulative flow depending on what data we are dealing with.
\*\*\*

### Instantaneous discharge

To better understand this subtlety, it might be just as easy to illustrate this using some actual data. In the example below, each open black dot represents *instantaneous* discharges computed every 10 min, and expressed in L/s.

![](time_series_flux_calculations_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-1-1.png)

### Mean discharge over an interval

Now, if we want to represent the "same" data but expressed as hourly *mean discharge*, the figure below is what it would really corresponds to, the red square showing the value that is effectively stored for the corresponding time stamp, and the red segment illustrate that the mean is calculated over 6 values spanning over an hour.
There are several things to notice: \* there is no red square for the 07:00 time stamp \* the segments have purposely been represented to visually span over the 6 values that are used to calculate the mean discharge over an hour. This means that the value at the top of the previous hour is not used to calculate the mean. This has some (small) consequences on the cumulative flow computations later on.
\* notice that for all time stamps on the top of the hour, the red square values are much lower than the instantaneous values at the same time. This is expected as in this case, the flow values are increasing. The opposite would be true, if the flow values were decreasing.

![](time_series_flux_calculations_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-2-1.png)

Calculating cumulative volume
-----------------------------

### First: using instantaneous flow

To calculate the cumulative volume from 07:00 to 12:00, let us start from the instantaneous data (open black circle). The proper way of doing this is to integrate the area under the trapeze defined by the consecutive dates as vertical boundaries, Q=0 for the lower horizontal boundary, and the the Q values for the upper side of the trapeze, as represented by the polygons in the left side of the graph below.
The cumulative flow (expressed in m³) is plotted on the right side of the figure. Notice that for time stamp 07:00, there is a value and it is 0.

![](time_series_flux_calculations_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-3-1.png) \#\#\# Second: using mean value over an interval

If we take the 'same' data expressed as *hourly mean discharge*, and we calculate the cumulative flow, this corresponds to integrating rectangles like in the left panel of the figure below. The cumulative values are plotted at red squares on the cumulative flow plot on the right panel of the figure below. \*\*\* ![](time_series_flux_calculations_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-4-1.png) Now, if you look really closely, you will see that the open circle are not quite in the middle of the squares, and this is not a mistake. The cumulative flow calculated as the mean discharge over a given period does not yield exactly what the integration of trapezes drawn from the instantaneous discharge!

In fact you can see in the table below the dicharges in (*m*<sup>3</sup>) and the percentage difference at each time stamp:

| time stamp          |  using Instantaneous Q|  using mean Q|  % difference|
|:--------------------|----------------------:|-------------:|-------------:|
| 1999-01-18 07:00:00 |                      0|             0|         NaN %|
| 1999-01-18 08:00:00 |                 339.96|        351.84|        3.38 %|
| 1999-01-18 09:00:00 |                 804.63|        824.28|        2.38 %|
| 1999-01-18 10:00:00 |                1373.19|       1402.38|        2.08 %|
| 1999-01-18 11:00:00 |                2057.43|       2095.98|        1.84 %|
| 1999-01-18 12:00:00 |                2839.53|       2885.28|        1.59 %|

------------------------------------------------------------------------

How can this be since the original data is exactly the same? It is because when averaging we are actually extrapolating the flow values. In the left panel of the figure below, we have represented the cumulated flow volume over one hour between the 09:00 and 10:00 time stamps with the red rectangle area, as calculated using the *mean discharge* computed as before. We have represented the same volume by the 6 small rectangles that represent what really happens when we average 6 instantaneous values into one mean one, and multiply by the 1-hr time resolution to obtain the flow volume within that hour. Notice that we are essentially extrapolating *values* to the left, and thus there is a little bit extra surface area compared to the trapezes one can draw between consecutive instantaneous flow measurements (right panel of the figure below).
\*\** ![](time_series_flux_calculations_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-5-1.png) Although we are supposed to represent, over the one hour interval, the *average\* or *mean* discharge, we are really using 6 out of the 7 values that would need to have a result value 'centered' over the entire interval. We are actually biasing *to the right* the flow volume calculations. The actual centroid of the mean is not centered at 09:30 in our example, but rather at 09:35. As the flow increases over the interval, the *mean discharge* over the interval is thus slightly overestimated, hence the extra volume calculated in our example here. This would be the case for all flow data reporting the 'mean discharge' over a given time interval.

In reality, because flow goes up and back down to the same baseflow at the hydrograph and the annual cycle, the overestimation induced when flow rises is largely compensated by volume underestimation when flow diminishes. To illustrate this, below is a hydrograph that was recorded in the coastal plain of North Carolina between the 3rd and 8th of January 1999. \*\*\* ![](time_series_flux_calculations_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-6-1.png)

    ## [1] "cumflow /instantaneous flow rates = 58816.58 m³"

    ## [1] "cumflow /mean hourly flow rates = 58814.53 m³"

Now, if we calculate the cumulative flow volume over the entire hydrograph, using each 10-min point as instantaneous flow, we shall calculate the cumulative volume to be 58816.58 m³, as shown in the calculation above. The calculation using the mean hourly discharge yields 58814.53 m³, or a difference of 0.03‰. Let us admit almost nothing...! However, when one does the calculation from the beginning to the hydrograph peak (@ 1999-01-03 15:00:00; see code below), the flow volume calculated using hourly mean discharge overestimates volumes calculated using 10-min instantaneous flow by 1.8%. Now things are not as negligible anymore. In the end, as long as the discharge values drop back down to their initial level, the difference is minor at best. \*\*\*

    ## [1] "cumflow during the rising limb /instantaneous flow rates = 7870.19 m³"

    ## [1] "cumflow during the rising limb /mean hourly flow rates = 7950.96 m³"

Mistakingly using mean discharge as instantaneous discharge
-----------------------------------------------------------

We have shown until now that the intermediate results on the flow volume calculations can be slightly different when computed using *instantaneous* vs *mean over a time interval* flow values, but negligible at the hydrograph scale, and therefore at the yearly scale as well.

Now, it becomes interesting to see whether the differences are still negligible if, unaware of the flow data type, one computes flow volume assuming *instantaneous flow values* (using the trapeze method), rather than *mean flow values over a time interval* (the rectangle method). For this, we used the mean hourly discharge data, and treated them as if they were instantaneous. To do that, and to compute cumulative flow using data as mean hourly values, we first took the value at 1999-01-03 01:00:00 out, otherwise the final cumulative flow values would not have been fully comparable. The figure below illustrates the difference in flow values.

For this example, we can see that the difference is still rather minor, i.e., 0.01% over the example hydrograph. One could really argue that not knowing the data type is not problematic and that there is little to worry about. And that is a fair statement in light of what has been shown in this article. Now we still want to advocate to preferentially use *instantaneous* discharge data, rather than *interval mean* values. \*\*\*

    ## [1] "cumflow during the rising limb /apparent instantaneous flow rates = 58590.5 m³"

    ## [1] "cumflow during the rising limb /hourly mean flow rates = 58579.2 m³"

![](time_series_flux_calculations_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-8-1.png)

Advocating for using instantaneous flow and concentration data to calculate fluxes
----------------------------------------------------------------------------------

The beauty of *interval-mean* values is that they tend to buffer some of the noise obtained during measurements for reasons mentioned above. High frequency water quality sensors which are on their way to be widely used, tend to report *instantaneous* concentrations, and not average values. We believe it is because sensor values need to be compared to laboratory ones, and that people feel more comfortable using instantaneous/discrete values rather than average ones.

One could be in the situation in a given watershed where concentration values would correspond to instantaneous values, while the flow rates would be *interval-means*. In this case, the data would actually be of different nature and we advocate that it would not be desirable to use them together. We advocate that the ideal situation would be to obtain *'instantaneous'* flow values from averages of 1-sec measurements over 30 sec or 1-min from stage and velocity sensors. This way, these *'instantaneous'* flow values would have the advantage of the *interval-average* values, in that much of the noise would be buffered by repeated measurements over short periods, and they would be comparable to isntantaneous concentrations measured by instantaneous sensors.

Last remark on using the *cumsum()* function to calculate cumulative fluxes
---------------------------------------------------------------------------

In r or in Matlab, the *cumsum()* function is very handy as it calculates for each time stamp, the cumulative sum of the series of value. The function *cumsum()* can calculate cumulative sums of millions of datapoints in a split second. We take a mock example time series (TS) below and we calculate the associated cumulative sum using the *cumsum()* function.
\*\*\*

    ##  [1]  9 16 21 24 25 24 21 16  9  0

    ##  [1]   9  25  46  70  95 119 140 156 165 165

![](time_series_flux_calculations_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-9-1.png)

Now, let us imagine that *TS* (for Time Series) values actually correspond to 1-sec instantaneous flow values in *L/s*, with the first and last values corresponding to the initial and final time over which we wish to calculate the cumulative volume. The flow volume would be calculated as: \*\*\*

    ##  [1]   0.0  12.5  31.0  53.5  78.0 102.5 125.0 143.5 156.0 160.5

Not surprisingly, this does not correspond to *cumTS* reported above, as we have shown that trapeze and rectangle areas (what *cumsum()* really does) do not match. This is rather disappointing because the *cumsum()* function is very quick and handy, and essentially assumes that one is dealing with the equivalent of *interval-mean* values. In fact, to calculate cumulative volumes from the 1-hr-mean values above, we used the *cumsum()* function.

But we can actually use a simple trick to still use the *cumsum()* function and yield the correct cumulative flow from *instantaneous* flow values. The trick is to calculate twice the *cumsum()* of slightly modified time series and take the average, just like in the code below.
\*\*\*

    ##  [1]   0.0  12.5  31.0  53.5  78.0 102.5 125.0 143.5 156.0 160.5

The trick is thus to remove the first value out of the calculation *'cumsum(TS\[-1\])'* to effectively calculate the geometrical equivalence of the red rectangles below. \*\*\*

![](time_series_flux_calculations_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-12-1.png)

The next trick is to remove the last value from the calculation *'cumsum(head(TS,-1))'* as represented by the blue rectangles below: \*\*\*

![](time_series_flux_calculations_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-13-1.png)

And take the average of the two, and add a 0 value at the beginning for the first time stamp, and we are done! \*\*\*

![](time_series_flux_calculations_files/figure-markdown_github-ascii_identifiers/unnamed-chunk-14-1.png)
