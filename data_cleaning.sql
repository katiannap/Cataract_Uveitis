[THORNE] Visual acuity outcomes of cataract surgery in patients with uveitis
	

--STEP 1: Create patient universe 

		--1a. First, we want to focus on coding the inclusion criteria.
		--We filter for patients in Madrid2 that have:
		--all ICD codes listed in SAP inclusion criteria with uveitis codes. 
		--have been diagnosed between 2013 and 2018 

		--1b. We are also creating the 'diagnosis_date' since we don’t have a diagnosis date column in Madrid2.
		--It is standard protocol to take which ever date is earliest between documentation_date and problem_onset_date in the patient_problem_laterality 
		--table in order to create the diagnosis date since they are both related to the diagnosis that the patient has. Our goal with
		--taking the earliest date is to eventually create the index date for when the patients entered this study.  
				  
		--1c. Get 1s and 2s for right and left eyes. Split 3s into 1s (right) and 2s (left). Get 4s for unspecified eyes.
		
		--1d. We UNION these three datasets to stack their results into one cohesive dataset. 


DROP TABLE IF EXISTS aao_grants.thorne_universe_new;

CREATE TABLE aao_grants.thorne_universe_new AS
SELECT DISTINCT
	patient_guid,
	practice_id,
	CASE WHEN documentation_date IS NULL THEN
		problem_onset_date
	WHEN problem_onset_date IS NULL THEN
		documentation_date
	WHEN (
		documentation_date IS NOT NULL
		AND problem_onset_date IS NOT NULL)
		AND problem_onset_date < documentation_date THEN
		problem_onset_date
	WHEN (
		documentation_date IS NOT NULL
		AND problem_onset_date IS NOT NULL)
		AND problem_onset_date > documentation_date THEN
		documentation_date
	WHEN (
		documentation_date IS NOT NULL
		AND problem_onset_date IS NOT NULL)
		AND problem_onset_date = documentation_date THEN
		documentation_date
	END AS diagnosis_date,
	problem_code AS uveitis_code,
	CASE WHEN diag_eye = '1' THEN
		1
	WHEN diag_eye = '2' THEN
		2
		WHEN diag_eye = '4' THEN
		4
	END AS uveitis_eye
FROM
	madrid2.patient_problem_laterality
WHERE (
	-- Noninfectious uveitis
	problem_code ILIKE '135%' -- Sarcoidosis uveitis
	OR problem_code = '363'
	OR problem_code = '364'
	OR problem_code = '364.0' -- Acute & subacute iridocyclitis
	OR problem_code = 'H20.0'
	OR problem_code = 'H30'
	OR problem_code = 'H30.0'
	OR problem_code = 'H30.1' -- Unspecified disseminated chorioretinal inflammation (chorioretinitis/choroiditis)
	OR problem_code = 'H30.8' -- Haradas disease
	OR problem_code = 'H30.9' -- Serpiginous choroiditis
	OR problem_code ILIKE '360.11%' -- Sympathetic uveitis
	OR problem_code ILIKE '360.12%' -- Panuveitis
	OR problem_code ILIKE '362.12%' -- Exudative retinopathy
	OR problem_code ILIKE '362.18%' -- Retinal vasculitis
	OR problem_code ILIKE '363.0%' -- Focal C-R and R-C Chorioretinal inflammation
	OR problem_code ILIKE '363.1%' -- Disseminated C-R and R-C
	OR problem_code ILIKE '363.2%' -- Other & unspecified C-R & R-C
	OR problem_code ILIKE '364.00%' --   Unspecified
	OR problem_code ILIKE '364.01%' --   Primary iridocyclitis
	OR problem_code ILIKE '364.02%' --   Recurrent iridocyclitis
	OR problem_code ILIKE '364.04%' --   2ary iridocyclitis
	OR problem_code ILIKE '364.05%' --   Hypopyon
	OR problem_code ILIKE '364.1%' -- Chronic iridocyclitis
	OR problem_code ILIKE '364.2%' -- Certain types of iridocyclitis
	OR problem_code ILIKE '364.3%' -- Unspecified iridocyclitis
	OR problem_code ILIKE '365.62%' -- Glaucoma secondary to eye inflammation
	OR problem_code ILIKE 'D86.8%' -- Sarcoidosis uveitis
	OR problem_code ILIKE 'D86.9%' -- Sarcoidosis uveitis
	OR problem_code ILIKE 'H20%' -- Iridocyclitis  / Disorders of iris and ciliary body
	OR problem_code ILIKE 'H20.00%'
	OR problem_code ILIKE 'H20.01%'
	OR problem_code ILIKE 'H20.02%'
	OR problem_code ILIKE 'H20.04%'
	OR problem_code ILIKE 'H20.05%'
	OR problem_code ILIKE 'H20.1%'
	OR problem_code ILIKE 'H20.2%'
	OR problem_code ILIKE 'H20.8%'
	OR problem_code ILIKE 'H20.9%'
	OR problem_code ILIKE 'H30.00%' -- Ampiginous choroiditis
	OR problem_code ILIKE 'H30.01%' -- Focal chorioretinal inflammation of posterior pole
	OR problem_code ILIKE 'H30.02%' -- Focal chorioretinal inflammation of posterior pole
	OR problem_code ILIKE 'H30.03%' -- Focal chorioretinal inflammation
	OR problem_code ILIKE 'H30.04%' -- Focal chorioretinal inflammation
	OR problem_code ILIKE 'H30.10%' -- Unspecified disseminated chorioretinal inflammation (chorioretinitis/choroiditis)
	OR problem_code ILIKE 'H30.11%' -- Disseminated chorioretinal inflammation (choroiditis/chorioretinitis) posterior pole
	OR problem_code ILIKE 'H30.12%' -- Disseminated chorioretinal inflammation (chorioretinitis/choroiditis) peripheral
	OR problem_code ILIKE 'H30.13%' -- Disseminated chorioretinal inflammation
	OR problem_code ILIKE 'H30.14%' -- APMPPE
	OR problem_code ILIKE 'H30.2%' -- Haradas disease
	OR problem_code ILIKE 'H30.8%' -- Haradas disease
	OR problem_code ILIKE 'H30.9%'
	OR problem_code ILIKE 'H35.02%' -- Exudative retinopathy
	OR problem_code ILIKE 'H35.06%' -- Retinal vasculitis
	OR problem_code ILIKE 'H40.4%'
	OR problem_code ILIKE 'H44.11%'
	OR problem_code ILIKE 'H44.13%'
	-- Infectious uveitis
	OR problem_code ILIKE '053.22%'
	OR problem_code ILIKE '054.44%'
	OR problem_code ILIKE '091.5%'
	OR problem_code ILIKE '094.83%'
	OR problem_code ILIKE '098.41%'
	OR problem_code ILIKE '115.02%'
	OR problem_code ILIKE '115.12%'
	OR problem_code ILIKE '130.2%'
	OR problem_code ILIKE '360.00%'
	OR problem_code ILIKE '360.01%'
	OR problem_code ILIKE '360.13%'
	OR problem_code ILIKE '364.03%'
	OR problem_code ILIKE 'A18.54%'
	OR problem_code ILIKE 'A52.19%'
	OR problem_code ILIKE 'A54.32%'
	OR problem_code ILIKE 'B00.51%'
	OR problem_code ILIKE 'B02.32%'
	OR problem_code ILIKE 'B58.01%'
	OR problem_code ILIKE 'H20.03%'
	OR problem_code ILIKE 'H33.12%'
	OR problem_code ILIKE 'H44.00%'
	OR problem_code ILIKE 'H44.01%'
	OR problem_code ILIKE 'H44.12%')
AND EXTRACT(
	YEAR FROM diagnosis_date) BETWEEN '2013'
AND '2018'
AND diag_eye in(
	'1', '2', '4')
UNION
SELECT DISTINCT
	patient_guid,
	practice_id,
	CASE WHEN documentation_date IS NULL THEN
		problem_onset_date
	WHEN problem_onset_date IS NULL THEN
		documentation_date
	WHEN (
		documentation_date IS NOT NULL
		AND problem_onset_date IS NOT NULL)
		AND problem_onset_date < documentation_date THEN
		problem_onset_date
	WHEN (
		documentation_date IS NOT NULL
		AND problem_onset_date IS NOT NULL)
		AND problem_onset_date > documentation_date THEN
		documentation_date
	WHEN (
		documentation_date IS NOT NULL
		AND problem_onset_date IS NOT NULL)
		AND problem_onset_date = documentation_date THEN
		documentation_date
	END AS diagnosis_date,
	problem_code AS uveitis_code,
	CASE WHEN diag_eye = '3' THEN
		1
	END AS uveitis_eye
FROM
	madrid2.patient_problem_laterality
WHERE (
	-- Noninfectious uveitis
	problem_code ILIKE '135%' -- Sarcoidosis uveitis
	OR problem_code = '363'
	OR problem_code = '364'
	OR problem_code = '364.0' -- Acute & subacute iridocyclitis
	OR problem_code = 'H20.0'
	OR problem_code = 'H30'
	OR problem_code = 'H30.0'
	OR problem_code = 'H30.1' -- Unspecified disseminated chorioretinal inflammation (chorioretinitis/choroiditis)
	OR problem_code = 'H30.8' -- Haradas disease
	OR problem_code = 'H30.9' -- Serpiginous choroiditis
	OR problem_code ILIKE '360.11%' -- Sympathetic uveitis
	OR problem_code ILIKE '360.12%' -- Panuveitis
	OR problem_code ILIKE '362.12%' -- Exudative retinopathy
	OR problem_code ILIKE '362.18%' -- Retinal vasculitis
	OR problem_code ILIKE '363.0%' -- Focal C-R and R-C Chorioretinal inflammation
	OR problem_code ILIKE '363.1%' -- Disseminated C-R and R-C
	OR problem_code ILIKE '363.2%' -- Other & unspecified C-R & R-C
	OR problem_code ILIKE '364.00%' --   Unspecified
	OR problem_code ILIKE '364.01%' --   Primary iridocyclitis
	OR problem_code ILIKE '364.02%' --   Recurrent iridocyclitis
	OR problem_code ILIKE '364.04%' --   2ary iridocyclitis
	OR problem_code ILIKE '364.05%' --   Hypopyon
	OR problem_code ILIKE '364.1%' -- Chronic iridocyclitis
	OR problem_code ILIKE '364.2%' -- Certain types of iridocyclitis
	OR problem_code ILIKE '364.3%' -- Unspecified iridocyclitis
	OR problem_code ILIKE '365.62%' -- Glaucoma secondary to eye inflammation
	OR problem_code ILIKE 'D86.8%' -- Sarcoidosis uveitis
	OR problem_code ILIKE 'D86.9%' -- Sarcoidosis uveitis
	OR problem_code ILIKE 'H20%' -- Iridocyclitis  / Disorders of iris and ciliary body
	OR problem_code ILIKE 'H20.00%'
	OR problem_code ILIKE 'H20.01%'
	OR problem_code ILIKE 'H20.02%'
	OR problem_code ILIKE 'H20.04%'
	OR problem_code ILIKE 'H20.05%'
	OR problem_code ILIKE 'H20.1%'
	OR problem_code ILIKE 'H20.2%'
	OR problem_code ILIKE 'H20.8%'
	OR problem_code ILIKE 'H20.9%'
	OR problem_code ILIKE 'H30.00%' -- Ampiginous choroiditis
	OR problem_code ILIKE 'H30.01%' -- Focal chorioretinal inflammation of posterior pole
	OR problem_code ILIKE 'H30.02%' -- Focal chorioretinal inflammation of posterior pole
	OR problem_code ILIKE 'H30.03%' -- Focal chorioretinal inflammation
	OR problem_code ILIKE 'H30.04%' -- Focal chorioretinal inflammation
	OR problem_code ILIKE 'H30.10%' -- Unspecified disseminated chorioretinal inflammation (chorioretinitis/choroiditis)
	OR problem_code ILIKE 'H30.11%' -- Disseminated chorioretinal inflammation (choroiditis/chorioretinitis) posterior pole
	OR problem_code ILIKE 'H30.12%' -- Disseminated chorioretinal inflammation (chorioretinitis/choroiditis) peripheral
	OR problem_code ILIKE 'H30.13%' -- Disseminated chorioretinal inflammation
	OR problem_code ILIKE 'H30.14%' -- APMPPE
	OR problem_code ILIKE 'H30.2%' -- Haradas disease
	OR problem_code ILIKE 'H30.8%' -- Haradas disease
	OR problem_code ILIKE 'H30.9%'
	OR problem_code ILIKE 'H35.02%' -- Exudative retinopathy
	OR problem_code ILIKE 'H35.06%' -- Retinal vasculitis
	OR problem_code ILIKE 'H40.4%'
	OR problem_code ILIKE 'H44.11%'
	OR problem_code ILIKE 'H44.13%'
	-- Infectious uveitis
	OR problem_code ILIKE '053.22%'
	OR problem_code ILIKE '054.44%'
	OR problem_code ILIKE '091.5%'
	OR problem_code ILIKE '094.83%'
	OR problem_code ILIKE '098.41%'
	OR problem_code ILIKE '115.02%'
	OR problem_code ILIKE '115.12%'
	OR problem_code ILIKE '130.2%'
	OR problem_code ILIKE '360.00%'
	OR problem_code ILIKE '360.01%'
	OR problem_code ILIKE '360.13%'
	OR problem_code ILIKE '364.03%'
	OR problem_code ILIKE 'A18.54%'
	OR problem_code ILIKE 'A52.19%'
	OR problem_code ILIKE 'A54.32%'
	OR problem_code ILIKE 'B00.51%'
	OR problem_code ILIKE 'B02.32%'
	OR problem_code ILIKE 'B58.01%'
	OR problem_code ILIKE 'H20.03%'
	OR problem_code ILIKE 'H33.12%'
	OR problem_code ILIKE 'H44.00%'
	OR problem_code ILIKE 'H44.01%'
	OR problem_code ILIKE 'H44.12%')
AND EXTRACT(
	YEAR FROM diagnosis_date) BETWEEN '2013'
AND '2018'
AND diag_eye in(
	'3')
UNION
SELECT DISTINCT
	patient_guid,
	practice_id,
	CASE WHEN documentation_date IS NULL THEN
		problem_onset_date
	WHEN problem_onset_date IS NULL THEN
		documentation_date
	WHEN (
		documentation_date IS NOT NULL
		AND problem_onset_date IS NOT NULL)
		AND problem_onset_date < documentation_date THEN
		problem_onset_date
	WHEN (
		documentation_date IS NOT NULL
		AND problem_onset_date IS NOT NULL)
		AND problem_onset_date > documentation_date THEN
		documentation_date
	WHEN (
		documentation_date IS NOT NULL
		AND problem_onset_date IS NOT NULL)
		AND problem_onset_date = documentation_date THEN
		documentation_date
	END AS diagnosis_date,
	problem_code AS uveitis_code,
	CASE WHEN diag_eye = '3' THEN
		2
	END AS uveitis_eye
FROM
	madrid2.patient_problem_laterality
WHERE (
	-- Noninfectious uveitis
	problem_code ILIKE '135%' -- Sarcoidosis uveitis
	OR problem_code = '363'
	OR problem_code = '364'
	OR problem_code = '364.0' -- Acute & subacute iridocyclitis
	OR problem_code = 'H20.0'
	OR problem_code = 'H30'
	OR problem_code = 'H30.0'
	OR problem_code = 'H30.1' -- Unspecified disseminated chorioretinal inflammation (chorioretinitis/choroiditis)
	OR problem_code = 'H30.8' -- Haradas disease
	OR problem_code = 'H30.9' -- Serpiginous choroiditis
	OR problem_code ILIKE '360.11%' -- Sympathetic uveitis
	OR problem_code ILIKE '360.12%' -- Panuveitis
	OR problem_code ILIKE '362.12%' -- Exudative retinopathy
	OR problem_code ILIKE '362.18%' -- Retinal vasculitis
	OR problem_code ILIKE '363.0%' -- Focal C-R and R-C Chorioretinal inflammation
	OR problem_code ILIKE '363.1%' -- Disseminated C-R and R-C
	OR problem_code ILIKE '363.2%' -- Other & unspecified C-R & R-C
	OR problem_code ILIKE '364.00%' --   Unspecified
	OR problem_code ILIKE '364.01%' --   Primary iridocyclitis
	OR problem_code ILIKE '364.02%' --   Recurrent iridocyclitis
	OR problem_code ILIKE '364.04%' --   2ary iridocyclitis
	OR problem_code ILIKE '364.05%' --   Hypopyon
	OR problem_code ILIKE '364.1%' -- Chronic iridocyclitis
	OR problem_code ILIKE '364.2%' -- Certain types of iridocyclitis
	OR problem_code ILIKE '364.3%' -- Unspecified iridocyclitis
	OR problem_code ILIKE '365.62%' -- Glaucoma secondary to eye inflammation
	OR problem_code ILIKE 'D86.8%' -- Sarcoidosis uveitis
	OR problem_code ILIKE 'D86.9%' -- Sarcoidosis uveitis
	OR problem_code ILIKE 'H20%' -- Iridocyclitis  / Disorders of iris and ciliary body
	OR problem_code ILIKE 'H20.00%'
	OR problem_code ILIKE 'H20.01%'
	OR problem_code ILIKE 'H20.02%'
	OR problem_code ILIKE 'H20.04%'
	OR problem_code ILIKE 'H20.05%'
	OR problem_code ILIKE 'H20.1%'
	OR problem_code ILIKE 'H20.2%'
	OR problem_code ILIKE 'H20.8%'
	OR problem_code ILIKE 'H20.9%'
	OR problem_code ILIKE 'H30.00%' -- Ampiginous choroiditis
	OR problem_code ILIKE 'H30.01%' -- Focal chorioretinal inflammation of posterior pole
	OR problem_code ILIKE 'H30.02%' -- Focal chorioretinal inflammation of posterior pole
	OR problem_code ILIKE 'H30.03%' -- Focal chorioretinal inflammation
	OR problem_code ILIKE 'H30.04%' -- Focal chorioretinal inflammation
	OR problem_code ILIKE 'H30.10%' -- Unspecified disseminated chorioretinal inflammation (chorioretinitis/choroiditis)
	OR problem_code ILIKE 'H30.11%' -- Disseminated chorioretinal inflammation (choroiditis/chorioretinitis) posterior pole
	OR problem_code ILIKE 'H30.12%' -- Disseminated chorioretinal inflammation (chorioretinitis/choroiditis) peripheral
	OR problem_code ILIKE 'H30.13%' -- Disseminated chorioretinal inflammation
	OR problem_code ILIKE 'H30.14%' -- APMPPE
	OR problem_code ILIKE 'H30.2%' -- Haradas disease
	OR problem_code ILIKE 'H30.8%' -- Haradas disease
	OR problem_code ILIKE 'H30.9%'
	OR problem_code ILIKE 'H35.02%' -- Exudative retinopathy
	OR problem_code ILIKE 'H35.06%' -- Retinal vasculitis
	OR problem_code ILIKE 'H40.4%'
	OR problem_code ILIKE 'H44.11%'
	OR problem_code ILIKE 'H44.13%'
	-- Infectious uveitis
	OR problem_code ILIKE '053.22%'
	OR problem_code ILIKE '054.44%'
	OR problem_code ILIKE '091.5%'
	OR problem_code ILIKE '094.83%'
	OR problem_code ILIKE '098.41%'
	OR problem_code ILIKE '115.02%'
	OR problem_code ILIKE '115.12%'
	OR problem_code ILIKE '130.2%'
	OR problem_code ILIKE '360.00%'
	OR problem_code ILIKE '360.01%'
	OR problem_code ILIKE '360.13%'
	OR problem_code ILIKE '364.03%'
	OR problem_code ILIKE 'A18.54%'
	OR problem_code ILIKE 'A52.19%'
	OR problem_code ILIKE 'A54.32%'
	OR problem_code ILIKE 'B00.51%'
	OR problem_code ILIKE 'B02.32%'
	OR problem_code ILIKE 'B58.01%'
	OR problem_code ILIKE 'H20.03%'
	OR problem_code ILIKE 'H33.12%'
	OR problem_code ILIKE 'H44.00%'
	OR problem_code ILIKE 'H44.01%'
	OR problem_code ILIKE 'H44.12%')
AND EXTRACT(
	YEAR FROM diagnosis_date) BETWEEN '2013'
AND '2018'
AND diag_eye in(
	'3'
);

SELECT * from aao_grants.thorne_universe_new; 

--1e. Patient count in cohort that have qualifying diagnoses
SELECT count(DISTINCT patient_guid) from aao_grants.thorne_universe_new; --1,417,058

--1f. Patient/eye count in cohort that have qualifying diagnoses
SELECT count(*) from (SELECT DISTINCT patient_guid, uveitis_eye from aao_grants.thorne_universe_new); --2,076,742


--STEP 2: Add 'index_date' column. Each unique ICD code results in a separate diagnosis.
--The ROWNUMBER window function allows us to take the earliest diagnosis date per eye per patient 
--and allows us to set that as the patient's index date (since diagnoses are eye specific).
--We want to do this because we want only the first diagnosis per patient eye, which is the 
--qualifying event for the patient to enter the cohort (we only need one qualifying event).

DROP TABLE IF EXISTS aao_grants.thorne_first_diagnoses;

CREATE TABLE aao_grants.thorne_first_diagnoses AS
(SELECT
	*
FROM (
	SELECT DISTINCT
		patient_guid,
		uveitis_eye,
		uveitis_code,
		diagnosis_date AS index_date,
		row_number() OVER (PARTITION BY patient_guid,
			uveitis_eye ORDER BY diagnosis_date ASC) AS rn,
			practice_id
		
	FROM
		aao_grants.thorne_universe_new)
WHERE
	rn = 1);


SELECT * from aao_grants.thorne_first_diagnoses;

SELECT count(DISTINCT patient_guid) from aao_grants.thorne_first_diagnoses; --1,417,058
SELECT count(*) from (SELECT DISTINCT patient_guid, uveitis_eye from aao_grants.thorne_first_diagnoses); --2,076,742


-- STEP 3: 3a. Get cataract procedures
		--We want to filter for patients in our cohort that have:
		--all CPT codes listed in SAP inclusion criteria + attached documents (email correspondence between Dr. Thorne and Scott) with cataract surgery codes. 
		--have had surgery between 2013 and 2018
		--NOTE: We are including unspecified eyes.

DROP TABLE IF EXISTS aao_grants.thorne_cataract_surgery_new;

CREATE TABLE aao_grants.thorne_cataract_surgery_new AS
SELECT
	patient_guid,
	procedure_date AS cataract_date,
	procedure_code AS cataract_code,
	CASE WHEN proc_eye = '4' THEN
		4
	WHEN proc_eye = '2' THEN
		2
	WHEN proc_eye = '1' THEN
		1
	END AS cataract_eye
FROM
	madrid2.patient_procedure_laterality p
WHERE
	patient_guid in(
		SELECT
			patient_guid FROM aao_grants.thorne_universe_new)
	and(
		procedure_code ILIKE '66840%'
		OR procedure_code ILIKE '66850%'
		OR procedure_code ILIKE '66852%'
		OR procedure_code ILIKE '66920%'
		OR procedure_code ILIKE '66930%'
		OR procedure_code ILIKE '66940%'
		OR procedure_code ILIKE '66982%'
		OR procedure_code ILIKE '66983%'
		OR procedure_code ILIKE '66984%')
	and(
		proc_eye IN ('4', '2', '1')
)
AND EXTRACT(
	YEAR FROM procedure_date) BETWEEN '2013'
AND '2018'
UNION
SELECT
	patient_guid,
	procedure_date AS cataract_date,
	procedure_code AS cataract_code,
	CASE WHEN proc_eye = '3' THEN
		1
	END AS cataract_eye
FROM
	madrid2.patient_procedure_laterality p
WHERE
	patient_guid in(
		SELECT
			patient_guid FROM aao_grants.thorne_universe_new)
	and(
		procedure_code ILIKE '66840%'
		OR procedure_code ILIKE '66850%'
		OR procedure_code ILIKE '66852%'
		OR procedure_code ILIKE '66920%'
		OR procedure_code ILIKE '66930%'
		OR procedure_code ILIKE '66940%'
		OR procedure_code ILIKE '66982%'
		OR procedure_code ILIKE '66983%'
		OR procedure_code ILIKE '66984%')
	and(
		proc_eye = '3'
)
AND EXTRACT(
	YEAR FROM procedure_date) BETWEEN '2013'
AND '2018'
UNION
SELECT
	patient_guid,
	procedure_date AS cataract_date,
	procedure_code AS cataract_code,
	CASE WHEN proc_eye = '3' THEN
		2
	END AS cataract_eye
FROM
	madrid2.patient_procedure_laterality 
WHERE
	patient_guid in(
		SELECT
			patient_guid FROM aao_grants.thorne_universe_new)
	and(
		procedure_code ILIKE '66840%'
		OR procedure_code ILIKE '66850%'
		OR procedure_code ILIKE '66852%'
		OR procedure_code ILIKE '66920%'
		OR procedure_code ILIKE '66930%'
		OR procedure_code ILIKE '66940%'
		OR procedure_code ILIKE '66982%'
		OR procedure_code ILIKE '66983%'
		OR procedure_code ILIKE '66984%')
	and(
		proc_eye = '3'
)
AND EXTRACT(
	YEAR FROM procedure_date) BETWEEN '2013'
AND '2018';


SELECT * from aao_grants.thorne_cataract_surgery_new;

--3b. Number of cohort patients that have has catarct surgery
SELECT count(DISTINCT patient_guid) from aao_grants.thorne_cataract_surgery_new; --421,955

--3c. Number of cohort patients/eyes that have has catarct surgery
SELECT count(*) from (SELECT DISTINCT patient_guid, cataract_eye from aao_grants.thorne_cataract_surgery_new); --675,597


--STEP 4: 4a. Patients must have uveitis diagnosis before cataract surgery
		--We must filter for patients that have had their index date before surgery.
		--We are joining on patient_guid and eye (uveitis and cataract) because this is eye level - We want to make sure that the same eye that has uveitis has had surgery. 
		
DROP TABLE IF EXISTS aao_grants.thorne_universe_join_new;

CREATE TABLE aao_grants.thorne_universe_join_new AS
SELECT DISTINCT
	d.patient_guid,
	d.uveitis_code,
	p.cataract_code,
	d.index_date,
	p.cataract_date,
	d.uveitis_eye,
	p.cataract_eye,
	practice_id
FROM
	aao_grants.thorne_first_diagnoses d
	INNER JOIN aao_grants.thorne_cataract_surgery_new p ON (
		d.patient_guid = p.patient_guid
			AND d.uveitis_eye = p.cataract_eye)
WHERE
	d.index_date < p.cataract_date;


SELECT * from aao_grants.thorne_universe_join_new;

--4b. Number of cohort patients that have had their uveitis diagnosis before cataract surgery
SELECT count(DISTINCT patient_guid) from aao_grants.thorne_universe_join_new; --78,892

--4c. Number of cohort patients/eyes that have had their uveitis diagnosis before cataract surgery
SELECT count(*) from (SELECT DISTINCT patient_guid, cataract_eye from aao_grants.thorne_universe_join_new); --93,082

-- STEP 5:  We are getting the age of each patient in the universe at index date.

		--5a. We subtact the year of index_date from year_of_birth.
		--We need to extract the year from index_date (YYYY-MM-DD) to match the date format that
		--year_of_birth (YYYY) is in. SQL cannot perform this function if the formats are different.

		--5b. We are looking for patients that are between 2 and 90 years old.
		
		--5c. We are joining aao_grants.thorne_universe_join_new to madrid2.patient to get the cohort's 
		--patients' age and yob data.  

DROP TABLE IF EXISTS aao_grants.thorne_dob_new;

CREATE TABLE aao_grants.thorne_dob_new AS

SELECT DISTINCT
	t.patient_guid,
	uveitis_eye,
	p.year_of_birth,
	extract(year FROM index_date) as index_date,
	(
		extract(year FROM index_date)) - year_of_birth AS age_at_index
FROM
	aao_grants.thorne_universe_join_new t
	LEFT JOIN madrid2.patient p ON t.patient_guid = p.patient_guid
WHERE
	age_at_index BETWEEN 2 AND 90;

SELECT * from aao_grants.thorne_dob_new;

--5d. Number of cohort patients that are between 2 and 90 years old 
SELECT count(DISTINCT patient_guid) from aao_grants.thorne_dob_new; --78,444

--5e. Number of cohort patients/eyes that are between 2 and 90 years old
SELECT count(*) from (SELECT DISTINCT patient_guid, uveitis_eye from aao_grants.thorne_dob_new); --92,590


-- STEP 6: Create complete inital cohort
		--We join aao_grants.thorne_universe_join_new to aao_grants.thorne_dob_new to get complete cohort data.
		--We will not scramble patient_guids because we are not giving a data cut to the RPB team for now.

DROP TABLE IF EXISTS aao_grants.rpb_thorne_universe_new;

CREATE TABLE aao_grants.rpb_thorne_universe_new AS SELECT DISTINCT
	u.patient_guid,
	u.uveitis_eye,
	cataract_eye,
	u.index_date,
	cataract_date,
	age_at_index,
	practice_id
FROM
	aao_grants.thorne_universe_join_new u
	INNER JOIN aao_grants.thorne_dob_new dob ON u.patient_guid = dob.patient_guid;

SELECT * from aao_grants.rpb_thorne_universe_new;


-- STEP 7: Get counts 

--7a. Number of patients in cohort
SELECT count(DISTINCT patient_guid) from aao_grants.rpb_thorne_universe_new; --78,444 

--7b. Number of total eyes in cohort
SELECT count(*) from (SELECT DISTINCT patient_guid, uveitis_eye from aao_grants.rpb_thorne_universe_new); --92,591

--7c. Number of right eyes in cohort
SELECT count(*) from (SELECT DISTINCT patient_guid, uveitis_eye from aao_grants.rpb_thorne_universe_new where uveitis_eye = '1'); --33,573

--7d. Number of left eyes in cohort
SELECT count(*) from (SELECT DISTINCT patient_guid, uveitis_eye from aao_grants.rpb_thorne_universe_new where uveitis_eye = '2'); --32,895

--7e. Number of unspecified eyes in cohort
SELECT count(*) from (SELECT DISTINCT patient_guid, uveitis_eye from aao_grants.rpb_thorne_universe_new where uveitis_eye = '4'); --26,123


-- STEP 8: 
		 --8a. We are processing the visual acuity per eye based on modified logmar.
		 --We must ensure that VA is between -0.3 AND 2.00 and not equal to 999 (this means that VA is missing).
		 --We are processing 1s (right), 2s (left), and 4s (unspecified) (eyes).


DROP TABLE IF EXISTS aao_grants.thorne_va_processing;

CREATE TABLE aao_grants.thorne_va_processing AS SELECT DISTINCT
	patient_guid,
	result_date,
	modified_logmar::real AS va,
	CASE WHEN eye = '1' THEN
		1
	WHEN eye = '2' THEN
		2
	WHEN eye = '4' THEN
		4
	END AS va_eye
FROM
	madrid2.patient_result_va
WHERE
	patient_guid in(
		SELECT DISTINCT
			patient_guid FROM aao_grants.rpb_thorne_universe_new)
	AND result_date BETWEEN '2013-01-01'
	AND '2018-12-31'
	AND modified_logmar <> '999'
	AND va BETWEEN - 0.30
	AND 2.00
	AND eye in(
		'1', '2', '4')
UNION
SELECT DISTINCT
	patient_guid,
	result_date,
	modified_logmar::real AS va,
	CASE WHEN eye = '3' THEN
		1
	END AS va_eye
FROM
	madrid2.patient_result_va
WHERE
	patient_guid in(
		SELECT DISTINCT
			patient_guid FROM aao_grants.rpb_thorne_universe_new)
	AND result_date BETWEEN '2013-01-01'
	AND '2018-12-31'
	AND modified_logmar <> '999'
	AND va BETWEEN - 0.30
	AND 2.00
	AND eye = '3'
UNION
SELECT DISTINCT
	patient_guid,
	result_date,
	modified_logmar::real AS va,
	CASE WHEN eye = '3' THEN
		2
	END AS va_eye
FROM
	madrid2.patient_result_va
WHERE
	patient_guid in(
		SELECT DISTINCT
			patient_guid FROM aao_grants.rpb_thorne_universe_new)
	AND result_date BETWEEN '2013-01-01'
	AND '2018-12-31'
	AND modified_logmar <> '999'
	AND va BETWEEN - 0.30
	AND 2.00
	AND eye = '3';


SELECT * from  aao_grants.thorne_va_processing;

--8b. Make sure that the VA result date is after cataract surgery
	--because we want to make sure we are measuring post operative BCVA.
	--Get time differences (in months) for next step.

DROP TABLE IF EXISTS aao_grants.thorne_va_processing_all;

CREATE TABLE aao_grants.thorne_va_processing_all AS SELECT DISTINCT
	a.*,
	b.index_date,
	b.cataract_date,
	datediff(
		month, b.cataract_date, a.result_date) AS monthdiff
FROM
	aao_grants.thorne_va_processing a
	INNER JOIN aao_grants.rpb_thorne_universe_new b ON a.patient_guid = b.patient_guid
		AND a.va_eye = b.uveitis_eye
WHERE
	b.cataract_date < a.result_date;


SELECT * from aao_grants.thorne_va_processing_all; 

--8c. We must get BCVA at 1 month post cataract surgery.
	--We have to get the closest VA value to 30 days (1 month) after cataract surgery by using the first_value window function.
	

DROP TABLE IF EXISTS aao_grants.thorne_va_processing2;

CREATE TABLE aao_grants.thorne_va_processing2 AS SELECT DISTINCT
	patient_guid,
	va_eye,
	one_month_va
FROM (
	SELECT DISTINCT
		a.*,
		first_value(va) OVER (PARTITION BY patient_guid,
			va_eye ORDER BY abs(datediff(day, cataract_date + 30, result_date)) ASC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS one_month_va
	FROM
		aao_grants.thorne_va_processing_all a
	WHERE
		monthdiff = 1
);

SELECT * from  aao_grants.thorne_va_processing2;
SELECT modified_logmar from madrid2.patient_result_va;

--8d. Get 1 month VA statistics.
	--We are looking for (one month post cataract surgery):
	--number of patients that have a VA measurement 
	--number of patients that have a VA measurement of 20/40 or better (Snellen values are commented out on the side)
	--average value of all patient's VA values  
	--minumum value of all patient's VA values  
	--maximum value of all patient's VA values  
	--standard deviation of all patient's VA values 
	--Q1 + Q3 values of all patient's VA values
	
SELECT
	'n' AS value,
	count(DISTINCT patient_guid)
FROM
	aao_grants.thorne_va_processing2
UNION
SELECT
	'n_20/40_or_better' AS value,
	count(DISTINCT patient_guid)
FROM
	aao_grants.thorne_va_processing2
	WHERE 
	(one_month_va = '0.3' --20/40
	OR one_month_va = '0.2' --20/32
	OR one_month_va = '0.18' --20/30
	OR one_month_va = '0.1' --20/25
	OR one_month_va = '0.0' --20/20
	OR one_month_va = '-0.1' --20/16
	OR one_month_va = '-0.2' --20/12.5
	OR one_month_va = '-0.3') --20/10
UNION
SELECT
	'mean' AS value,
	avg(one_month_va)
FROM
	aao_grants.thorne_va_processing2
UNION
SELECT
	'min' AS value,
	min(one_month_va)
FROM
	aao_grants.thorne_va_processing2
UNION
SELECT
	'max' AS value,
	max(one_month_va)
FROM
	aao_grants.thorne_va_processing2
UNION
SELECT
	'stddev' AS value,
	stddev(one_month_va)
FROM
	aao_grants.thorne_va_processing2
UNION
SELECT
	'Q1' AS value,
	percentile_cont(0.25)
	WITHIN GROUP (ORDER BY one_month_va)
FROM
	aao_grants.thorne_va_processing2
UNION
SELECT
	'Q3' AS value,
	percentile_cont(0.75)
	WITHIN GROUP (ORDER BY one_month_va) AS Q3
FROM
	aao_grants.thorne_va_processing2;


--8e. We must get BCVA at 3 months post cataract surgery.
	--We have to get the closest VA value to 90 days (3 month) after cataract surgery by using the first_value window function.
	
DROP TABLE IF EXISTS aao_grants.thorne_va_processing3;

CREATE TABLE aao_grants.thorne_va_processing3 AS SELECT DISTINCT
	patient_guid,
	va_eye,
	three_month_va
FROM (
	SELECT DISTINCT
		a.*,
		first_value(va) OVER (PARTITION BY patient_guid,
			va_eye ORDER BY abs(datediff(day, cataract_date + 90, result_date)) ASC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS three_month_va
	FROM
		aao_grants.thorne_va_processing_all a
	WHERE
		monthdiff = 3
);

SELECT * from  aao_grants.thorne_va_processing3;

--8f. Get 3 month VA statistics.
	--We are looking for (three month post cataract surgery):
	--number of patients that have a VA measurement 
	--number of patients that have a VA measurement of 20/40 or better 
	--average value of all patient's VA values  
	--minumum value of all patient's VA values  
	--maximum value of all patient's VA values  
	--standard deviation of all patient's VA values 
	--Q1 + Q3 values of all patient's VA values
	
SELECT
	'n' AS value,
	count(DISTINCT patient_guid)
FROM
	aao_grants.thorne_va_processing3
UNION
SELECT
	'n_20/40_or_better' AS value,
	count(DISTINCT patient_guid)
FROM
	aao_grants.thorne_va_processing3
WHERE 
	(three_month_va = '0.3' --20/40
	OR three_month_va = '0.2' --20/32
	OR three_month_va = '0.18' --20/30
	OR three_month_va = '0.1' --20/25
	OR three_month_va = '0.0' --20/20
	OR three_month_va = '-0.1' --20/16
	OR three_month_va = '-0.2' --20/12.5
	OR three_month_va = '-0.3') --20/10
UNION
SELECT
	'mean' AS value,
	avg(three_month_va)
FROM
	aao_grants.thorne_va_processing3
UNION
SELECT
	'min' AS value,
	min(three_month_va)
FROM
	aao_grants.thorne_va_processing3
UNION
SELECT
	'max' AS value,
	max(three_month_va)
FROM
	aao_grants.thorne_va_processing3
UNION
SELECT
	'stddev' AS value,
	stddev(three_month_va)
FROM
	aao_grants.thorne_va_processing3
UNION
SELECT
	'Q1' AS value,
	percentile_cont(0.25)
	WITHIN GROUP (ORDER BY three_month_va::float)
FROM
	aao_grants.thorne_va_processing3
UNION
SELECT
	'Q3' AS value,
	percentile_cont(0.75)
	WITHIN GROUP (ORDER BY three_month_va::float) AS Q3
FROM
	aao_grants.thorne_va_processing3;


--STEP 9: Gather demographic variables for all patient eyes in the universe 

		--9a. Gather race, gender, and age group information
DROP TABLE IF EXISTS aao_grants.thorne_demog;

CREATE TABLE aao_grants.thorne_demog AS SELECT DISTINCT
	u.*,
	p.gender,
	CASE WHEN p.ethnicity = 'Hispanic or Latino' THEN
		'Hispanic'
	ELSE
		p.race
	END AS race_final
FROM
	aao_grants.rpb_thorne_universe_new u
	INNER JOIN madrid2.patient p ON u.patient_guid = p.patient_guid;

SELECT * from aao_grants.thorne_demog;

--9b. Gather counts per race.
SELECT  race_final, count(distinct patient_guid) from aao_grants.thorne_demog group by race_final ORDER BY race_final;

--9c. Gather counts per gender.
SELECT  gender, count(distinct patient_guid) from aao_grants.thorne_demog group by gender ORDER BY gender;

--9d. Get age statistics.  
	--We are looking for:
	--average value of all patient's ages  
	--minumum value of all patient's ages  
	--maximum value of all patient's ages  
	--standard deviation of all patient's ages 
	--Q1 + Q3 values of all patient's ages
	
	
SELECT
	'age_average' AS value,
	AVG(age_at_index)
FROM
	aao_grants.thorne_demog
UNION
SELECT
	'age_min' AS value,
	min(age_at_index)
FROM
	aao_grants.thorne_demog
UNION
SELECT
	'age_max' AS value,
	max(age_at_index)
FROM
	aao_grants.thorne_demog
UNION
SELECT
	'age_stddev' AS value,
	stddev(age_at_index)
FROM
	aao_grants.thorne_demog
UNION
SELECT
	'age_Q1' AS value,
	percentile_cont(0.25)
	WITHIN GROUP (ORDER BY age_at_index::float)
FROM
	aao_grants.thorne_demog
UNION
SELECT
	'age_Q3' AS value,
	percentile_cont(0.75)
	WITHIN GROUP (ORDER BY age_at_index::float) AS Q3
FROM
	aao_grants.thorne_demog;



--STEP 10: Insurance processing

---10a. Since a patient may have had multiple types of insurance, we want to follow a prioritization hierarchy so that each
---patient is assigned to only one insurance type.

---NOTE: When reporting the output/interpreting the SAP, "Medicare Advantage" is equivalent to "Medicare Managed"

--We are casing our insurance variables into buckets due to standard protocol:
--Govt
--Medicaid
--Medicare FFS
--Medicare Managed
--Military
--Private
--Unknown/Missing

DROP TABLE IF EXISTS aao_grants.thorne_ins_process1;
CREATE TABLE aao_grants.thorne_ins_process1 AS SELECT DISTINCT
	patient_guid,
	insurance_type,
	CASE WHEN insurance_type ILIKE '%No Insurance%' THEN
		1
	ELSE
		0
	END AS npl,
	CASE WHEN insurance_type ILIKE '%Misc%' THEN
		1
	ELSE
		0
	END AS misc,
	CASE WHEN insurance_type ILIKE 'Medicare' THEN
		1
	ELSE
		0
	END AS mc_ffs,
	CASE WHEN insurance_type ILIKE '%Advantage%' THEN
		1
	ELSE
		0
	END AS mc_mngd,
	CASE WHEN insurance_type ILIKE '%Military%' THEN
		1
	ELSE
		0
	END AS mil,
	CASE WHEN insurance_type ILIKE '%Govt%' THEN
		1
	ELSE
		0
	END AS govt,
	CASE WHEN insurance_type ILIKE '%Medicaid%' THEN
		1
	ELSE
		0
	END AS medicaid,
	CASE WHEN insurance_type ILIKE '%Commercial%' THEN
		1
	ELSE
		0
	END AS private,
	CASE WHEN (
		insurance_type ILIKE '%Unknown%'
		OR insurance_type IS NULL) THEN
		1
	ELSE
		0
	END AS unkwn
FROM
	madrid2.patient_insurance
WHERE
	patient_guid in(
		SELECT DISTINCT
			patient_guid FROM aao_grants.thorne_demog
);

---10b. Sum the indicators
	--We are summing up all the 1s and 0s in each insurance bucket.
	
drop table if exists aao_grants.thorne_ins_process2;
CREATE TABLE aao_grants.thorne_ins_process2 AS SELECT DISTINCT
	patient_guid,
	sum(
		npl) AS npl_sum,
	sum(
		misc) AS misc_sum,
	sum(
		mc_ffs) AS mc_ffs_sum,
	sum(
		mc_mngd) AS mc_mngd_sum,
	sum(
		mil) AS mil_sum,
	sum(
		govt) AS govt_sum,
	sum(
		medicaid) AS medicaid_sum,
	sum(
		private) AS private_sum,
	sum(
		unkwn) AS unkwn_sum
FROM
	aao_grants.thorne_ins_process1
GROUP BY
	patient_guid;

---10c. Denote categories
	--We are naming the insurance bucket that we created.
	
drop table if exists aao_grants.thorne_ins_process_final;
CREATE TABLE aao_grants.thorne_ins_process_final AS SELECT DISTINCT
	patient_guid,
	CASE WHEN mc_ffs_sum > 0 THEN
		'Medicare FFS'
	WHEN mc_mngd_sum > 0 THEN
		'Medicare Managed'
	WHEN medicaid_sum > 0 THEN
		'Medicaid'
	WHEN mil_sum > 0 THEN
		'Military'
	WHEN govt_sum > 0 THEN
		'Govt'
	WHEN private_sum > 0 THEN
		'Private'
	WHEN misc_sum > 0 THEN
		'Private'
	WHEN (
		unkwn_sum > 0
		OR npl_sum > 0) THEN
		'Unknown'
	ELSE
		'Unknown'
	END AS ins_final
FROM
	aao_grants.thorne_ins_process2;
 
---10d. Join back to master dataframe, and assign pts who are not in the insurance table as 'Unknown'
	--We do this because want to match up our cohort's patients to their respective insurance.
drop table if exists aao_grants.thorne_with_insurance; 
CREATE TABLE aao_grants.thorne_with_insurance AS SELECT DISTINCT
	u.*,
	CASE WHEN b.ins_final = 'Unknown'
		OR b.ins_final IS NULL THEN
		'Unknown/Missing'
	ELSE
		b.ins_final
	END AS insurance_new
FROM
	aao_grants.thorne_demog u
	LEFT JOIN aao_grants.thorne_ins_process_final b ON u.patient_guid = b.patient_guid;


select * from aao_grants.thorne_with_insurance;

--10e. We are counting the amount of patients in each insurance category.

SELECT insurance_new, count(DISTINCT patient_guid) from aao_grants.thorne_with_insurance GROUP by insurance_new ORDER by insurance_new;

--STEP 11: 
	---11a. Get smoking status
	---Goal: Similarly (to 10a.), since a patient may have had multiple smoking statuses, we want to follow a prioritization hierarchy so that each
	---patient is assigned to only one smoking status

DROP TABLE IF EXISTS aao_grants.thorne_smoking_step_1;

CREATE TABLE aao_grants.thorne_smoking_step_1 AS SELECT DISTINCT
	patient_guid,
	first_value(
		social_history_status_description) OVER ( PARTITION BY patient_guid ORDER BY social_hx_priority ASC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS smoking_status
FROM (
	SELECT DISTINCT
		patient_guid,
		social_history_status_description,
		CASE WHEN social_history_status_description = 'Yes / Active' THEN
			1
		WHEN social_history_status_description = 'Former / No longer active / Past History / Quit' THEN
			2
		WHEN social_history_status_description = 'No / Never' THEN
			3
		WHEN social_history_status_description = 'Unknown / Unclassified' THEN
			4
		END AS social_hx_priority
	FROM
		madrid2.patient_social_history_observation
	WHERE
		social_history_type_code = '11'
		AND patient_guid in( SELECT DISTINCT
				patient_guid FROM aao_grants.thorne_with_insurance)
);

DROP TABLE IF EXISTS aao_grants.thorne_with_smoking;
CREATE TABLE aao_grants.thorne_with_smoking AS SELECT DISTINCT
	u.*,
	CASE WHEN b.smoking_status IS NULL THEN
		'Unknown / Unclassified'
	ELSE
		b.smoking_status
	END AS smoke_status
FROM
	aao_grants.thorne_with_insurance u
	LEFT JOIN aao_grants.thorne_smoking_step_1 b ON u.patient_guid = b.patient_guid;

SELECT * FROM aao_grants.thorne_with_smoking;


--11b. We are counting the amount of patients in each smoking category.
SELECT smoke_status, COUNT(DISTINCT patient_guid) from aao_grants.thorne_with_smoking GROUP by smoke_status ORDER by smoke_status;


--STEP 12: Process provider region 
	--12a. To assign practices to a single ZIP and/or state, we are simply filtering out all 
	--records with missing values for ZIP and/or state, and then taking whichever practice 
	--location record has the most recent update_time for each practice_id

DROP TABLE IF EXISTS aao_grants.thorne_all_practice_locations;

CREATE TABLE aao_grants.thorne_all_practice_locations AS SELECT DISTINCT
	b.practice_id,
	state_code,
	update_time
FROM
	madrid2.practice_location b
WHERE
	b.practice_id in(
		SELECT DISTINCT
			u.practice_id FROM aao_grants.thorne_with_smoking u
);

SELECT count(*) from aao_grants.thorne_all_practice_locations; --17,041

DROP TABLE IF EXISTS aao_grants.thorne_one_practice_location;

CREATE TABLE aao_grants.thorne_one_practice_location AS
SELECT
	*
FROM (
	SELECT DISTINCT
		a.*,
		ROW_NUMBER() OVER (PARTITION BY practice_id ORDER BY update_time DESC) AS rn
	FROM
		aao_grants.thorne_all_practice_locations a
	WHERE
		state_code IS NOT NULL ORDER BY
			practice_id, update_time DESC)
	WHERE
		rn = 1;


SELECT count(*) from aao_grants.thorne_one_practice_location; --2,440

DROP TABLE IF EXISTS aao_grants.thorne_with_region;

CREATE TABLE aao_grants.thorne_with_region AS SELECT DISTINCT
	u.*,
	CASE WHEN c.region IS NULL THEN
		'Unknown'
	ELSE
		c.region
	END AS practice_region
FROM
	aao_grants.thorne_with_smoking u
	LEFT JOIN aao_grants.thorne_one_practice_location pd ON u.practice_id = pd.practice_id
	LEFT JOIN aao_team.map_region c ON pd.state_code = c.state_code;


SELECT * from aao_grants.thorne_with_region;
SELECT count(*) from aao_grants.thorne_with_region;
SELECT count(DISTINCT patient_guid) from aao_grants.thorne_with_region;

--12b. We are counting the amount of patients in each region category. 
SELECT practice_region, COUNT(DISTINCT patient_guid) from aao_grants.thorne_with_region GROUP by practice_region ORDER by practice_region;
select count(distinct practice_id) from aao_grants.thorne_with_region where practice_region = 'Unknown';
