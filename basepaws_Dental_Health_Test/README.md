<table>
  <tbody>
    <tr>
      <th align="center">Sample</th>
      <th align="center">Periodontal</br>Disease</th>
      <th align="center">Tooth</br>Resorption</th>
	    <th align="center">Bad</br>Breath</th>
    </tr>
    <tr>
      <th align="center">~15x WGS</br>3-14-2019</th>
      <th align="center">High Risk</br>(7.35)</th>
      <th align="center">High Risk</br>(9.98)</th>
	<th align="center">Low Risk</br>(0.34)</th>
    </tr>
    <tr>
      <th align="center">Dental Health</br>(<i>mostly lick</i>)</br>6-7-2021</th>
      <th align="center">High Risk</br>(7.89)</th>
      <th align="center">High Risk</br>(9.58)</th>
	<th align="center">Low Risk</br>(0.05)</th>
    </tr>
    <tr>
      <th align="center">Dental Health</br>(<i>mostly lick</i>)</br>6-8-2021</th>
      <th align="center">High Risk</br>(6.68)</th>
      <th align="center">High Risk</br>(9.76)</th>
	<th align="center">Low Risk</br>(0.02)</th>
    </tr>
    <tr>
      <th align="center">Dental Health</br>(<i>mostly lick</i>)</br>6-9-2021</th>
      <th align="center">High Risk</br>(7.73)</th>
      <th align="center">High Risk</br>(9.65)</th>
	<th align="center">Low Risk</br>(0.18)</th>
    </tr>
</tbody>
</table>


## **basepaws (mouth swab, ~15x [Whole Genome Sequencing](https://basepaws.com/products/whole-genome-sequencing), with raw data as FASTQ+BAM+gVCF)**:

Activated Kit / Collected Sample on 3/14/2019

I noticed that a report is now provided for my earlier Whole Genome Sequencing sample, which I have uploaded.

While raw data is not available for the separate Dental Health Test, you can see the raw data for my regular coverage WGS here:

*basepaws 15x WGS Read1*: https://storage.googleapis.com/bastu-cat-genome/HCWGS0003.23.HCWGS0003_1.fastq.gz

*basepaws 15x WGS Read2*: https://storage.googleapis.com/bastu-cat-genome/HCWGS0003.23.HCWGS0003_2.fastq.gz

Because the raw data is available, I added the following scripts (uploaded in this folder, along with output reformated as Excel files):

***a)*** *run_Kracken2_Bracken-FASTQ-PE.py*  - runs Kraken2 and Bracken

***b)*** *filter_Bracken.R* - filters Braken species-level assignment for those listed in the Supplemental Table of ([Kao et al. 2021](https://www.biorxiv.org/content/10.1101/2021.04.23.441192v1)). **Please note this script does *not* currently work as intended.**

## **basepaws ([Dental Health Test](https://basepaws.com/products/cat-dental-health-test), $69-$79 each, 4 samples, Order #31272)**:

Samples were ordered on 5/30/2021.

All 4 kits arrived on 6/7/2021.

I collected the **1st sample** (ID 31201053202314) on **6/7/2021**.  Bastu mostly licked the foam collector, so hopefully that is OK (versus having more direct contact with her teeth).  The prior training helped keep her from running away, but he hasn't quite figured out what is earning her the treat afterwards.

I collected the **2nd sample** (ID 31201053201942) on **6/8/2021**.  Again, Bastu mostly licked the foam collector.

I collected the **3rd sample** (ID 31201053202280) on **6/9/2021**.  Again, Bastu mostly licking, but I think less than the previous days.  Towards the ends, I might have had something closer to the ideal interaciton in the mouth, but I then stopped to give a treat (and, hopefully, build off that later).

Accordingly, I have decided not to submit my *4th sample*.  Instead, I will try to use that for training, and maybe try again for the oral samples at a later date.  The actual collection tube will have the right shape, and I have already ordered baby oral cleaners (such as [here](https://smile.amazon.com/gp/product/B08K4RDVH1)) for previous training.  If I can find a way to temporarily attach the oral cleaner to the collection device, then I think I can have something sterile that I can use for training?

I was able to download all 3 results on **7/9/2021**.

## **basepaws ([Dental Health Test](https://basepaws.com/products/cat-dental-health-test), $59 each, 1 sample, Order #32719)**:

I ordered 1 additional sample that I hope to have a vet help me collect on 7/11/2021 (which was delivered to my apartment on 7/22/2021).

## Prevalence Notes (mostly copied from [blog post](http://cdwscience.blogspot.com/2019/12/review-of-results-data-from-3-cat-dna.html))

On [one of the basepaws websites](https://basepaws.com/pages/cat-dental-health-test), it says "*It is estimated that 50-90% of ALL adult cats have a dental health problem, with periodontal disease being the number one culprit*."

I did see a similar number (50-90%) reported on [this page](https://www.vet.cornell.edu/departments-centers-and-institutes/cornell-feline-health-center/health-information/feline-health-topics/feline-dental-disease) for cats.

For any level of severity, if you count 50-70% as being similar, then that overlaps what is reported [here](https://vcahospitals.com/know-your-pet/dental-disease-in-cats) and perhaps pages 10-11 of the **2016 report** that can be downloaded [here](https://www.banfield.com/pet-health/State-of-pet-health).

***However, I think that is different than what a lot of people might think of for "*periodontal disease*"?***

For example, I think the claim about prevalence looks different than I see in [this paper](https://bmcvetres.biomedcentral.com/articles/10.1186/s12917-021-02775-3/tables/1) on dogs. Likewise, I can also see [this paper](https://pubmed.ncbi.nlm.nih.gov/25178688/) where the prevalence is more similar to what I saw in cats (**10-15%** for **periodontal disease**, which was in fact reported as being the most common specific disease)

Possibly somewhere in between (?), in [this paper](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5002895/), there was a fraction of overall "*dental problems*" being reported in the abstract is ~30%.

I don't see dental problems listed on [this ASPCA page](https://www.aspca.org/pet-care/cat-care/common-cat-diseases), (or, I believe, [this Wikipedia page](https://en.wikipedia.org/wiki/Cat_health)).  So, I am not sure what to think about that.

I will continue to gradually look into this more, but the "periodontal disease stage" for dogs (and stage I, for cats) in the [2016 VCA report](https://www.banfield.com/pet-health/State-of-pet-health) with a higher percentage for "*dental tartar*" (greater than 50%, for ages greater than 1 year) seems like what I was expecting (with values **<10%** for **stage I periodontal disease** cats, and varying fractions by age for dog that are also all <10%).

For example, in the ([Kao et al. 2021](https://www.biorxiv.org/content/10.1101/2021.04.23.441192v1)) preprint for the basepaws Dental Health Test, I believe **9.3%** (570 / 6110) of the **filtered** cats / samples had periodontal disease.

## Other Notes

As I collect more data, I will comment on the preprint ([Kao et al. 2021](https://www.biorxiv.org/content/10.1101/2021.04.23.441192v1)).  Already, I think the company is supposed to declare a *competing interest*, because this relates to a product that they are be selling.  However, I am waiting to say more about the scientific details (and implications for individuals purchasing the test).

I think there is at least some misunderstanding, which I could determine based upon an answer in the [Basepaws Cat Club](https://www.facebook.com/groups/basepaws/permalink/2957599151162943) Facebook group.  Based upon what I see in another individual's report, I think the plots next to the scores are for individual bacteria (versus cats in the healthy and/or disease training groups)?  I am going to follow-up via e-mail.  Neverthless, I would like to see what the plot looks like for scores among cats that have been tested, and I am also curious what the *score distribution looks like in new, independent samples*.

I think I may also ask if the liquid in the collection material has something to reduce or prevent [post-collection bacterial "blooms"](https://www.nature.com/articles/d42473-018-00136-7).

My understanding is that age is a risk factor.  I like that I don't see any obvious over-fitting in the results (with accuracy that seems more than random, but certainly not perfectly predictive).  However, is the microbiome score providing an advantage over known risk factors?

I thought I saw something about early detection mentioned somewhere.  However, if that was emphasized, then I think the experimental design would be different for samples collected before the disease onset versus trying to understand the basis of the disease in cats that already have symptoms.

I am not sure if it might also be worth looking more into some of the referneces for [this article](https://californianewstimes.com/basepaws-has-a-dna-test-for-your-cats-teeth-does-it-work/377746/).
