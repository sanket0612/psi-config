select
pi.identifier as 'OI No',
CONCAT(pn.given_name, " ", COALESCE(pn.middle_name, '')) as "Name",
pn.family_name as Surname,
case
    when p.gender = 'M' then 'Male'
    when p.gender = 'F' then 'Female'
    when p.gender = 'O' then 'Other'
    end as "Sex",
TIMESTAMPDIFF(YEAR, p.birthdate, CURDATE()) as Age,
GROUP_CONCAT(DISTINCT (case when pat.name = 'Population' then cv1.concept_full_name else null end)) as "Category",
/*Wks on ART : If ART Stop date is present then ART stop date Else report end date for calculation*/
ROUND(DATEDIFF(
case when (select obs.value_datetime from obs 
INNER JOIN concept_view on obs.concept_id=concept_view.concept_id and concept_view.concept_full_name = "PR, ART Program Stop Date" and obs.voided=0 
where obs.person_id = pa.patient_id) is null then date('#endDate#') 
else 
(select obs.value_datetime from obs 
INNER JOIN concept_view on obs.concept_id=concept_view.concept_id and concept_view.concept_full_name = "PR, ART Program Stop Date" and obs.voided=0 
where obs.person_id = pa.patient_id) 
END, o.value_datetime) / 7, 0) as "Wks on ART",
piu.identifier as "UIC",
GROUP_CONCAT(distinct (case when pat.name = 'Mother\'s name' Then pac.value else null end)) as "Mother's name",
GROUP_CONCAT(distinct (case when pat.name = 'District of Birth' then cv1.concept_full_name else null end)) as "District of Birth",
GROUP_CONCAT(distinct (case when pat.name = 'Telephone' then pac.value else null end)) as "Telephone no",
GROUP_CONCAT(distinct (case when pat.name = 'Referral source' then case when cv1.concept_short_name is null then cv1.concept_full_name else cv1.concept_short_name end else null end)) as "Referred from",
group_concat(distinct d.name) as "Regime",
date(max(v.date_started)) as "Date Last seen",
date(max(pai.start_date_time)) as "Date of last Scheduled Visit"
from
patient pa
INNER JOIN obs o on pa.patient_id = o.person_id
INNER join concept_view cv on o.concept_id=cv.concept_id and cv.concept_full_name = 'PR, Start date of ART program' and o.voided=0 
and o.person_id not in 
         (/*Patient with ART stop date <= report end date then remove the patient else show the patient for the past period.*/
         select obs.person_id from obs INNER JOIN concept_view on obs.concept_id=concept_view.concept_id and concept_view.concept_full_name = "PR, ART Program Stop Date" and obs.voided=0
         Where obs.value_datetime <= Date('#endDate#'))
Inner join patient_appointment pai on pa.patient_id = pai.patient_id and pai.status='Scheduled' and pai.appointment_service_id = (select
appointment_service_id from appointment_service where name= 'ART')
and pa.patient_id not in(
                        Select patient_id from
                        patient_appointment futureAppointments
                        where futureAppointments.patient_id=pa.patient_id
                        And futureAppointments.status in ("Completed","CheckedIn")
                        and futureAppointments.start_date_time > pai.start_date_time
                         )
-- and pai.patient_appointment_id
--  NOT in
--  (select pa1.patient_id from patient_appointment pa1
--     INNER JOIN patient_appointment pa2
--     on pa1.patient_id = pa2.patient_id and pa1.status in ("Scheduled") and pa2.status in ("Completed","CheckedIn")
--     and pa1.start_date_time < pa2.start_date_time)

LEFT JOIN orders ord on pa.patient_id=ord.patient_id and ord.order_type_id = 2
LEFT JOIN drug_order dord on dord.order_id = ord.order_id
LEFT JOIN drug d on dord.drug_inventory_id = d.drug_id and d.name in ("Tenofovir (TDF) 300mg + Lamivudine (3TC) 300mg + Efavirenz (EFV) 600mg",
                "Tenofovir (TDF) 300mg + Lamivudine (3TC) 300mg + Efavirenz (EFV) 400mg",
                "Zidovudine (AZT) 300mg + Lamivudine (3TC) 150mg + Nevirapine (NVP) 200mg",
                "Zidovudine (AZT) 60mg + Lamivudine (3TC) 30mg + Nevirapine (NVP) 50mg",
                "Tenofovir (TDF) 300mg + Lamivudine (3TC) 300mg",
                "Tenofovir (TDF) 300mg + Emtricitabine 200mg",
                "Zidovudine (AZT) 300mg + Lamivudine (3TC) 150mg",
                "Zidovudine (AZT) 60mg + Lamivudine (3TC) 30mg",
                "Abacavir 600mg / Lamivudine 300mg",
                "Abacavir 60mg / Lamivudine 30mg",
                "Atazanavir/Rtv 300/100 mg",
                "Lopinavir/Rtv 80/20 mg/ml",
                "Lopinavir/Rtv 100/25 mg",
                "Lopinavir/Rtv 200/50 mg",
                "Lamivudine (3TC) 150 mg",
                "Lamivudine (3TC) 50mg/5ml",
                "Efavirenz (EFV) 50 mg",
                "Efavirenz (EFV) 200 mg",
                "Efavirenz (EFV) 600 mg",
                "Zidovudine (AZT) 300 mg",
                "Zidovudine (AZT) 100mg",
                "Zidovudine (AZT) 50mg/5ml",
                "Abacavir (ABC) 20mg/ml",
                "Abacavir (ABC) 300 mg",
                "Abacavir (ABC) 60mg",
                "Nevirapine (NVP) 50mg/5ml",
                "Nevirapine (NVP) 200mg",
                "Didanosine (ddl) 125mg",
                "Didanosine (ddl) 200mg",
                "Didanosine (ddl) 250mg",
                "Didanosine (ddl) 25mg",
                "Didanosine (ddl) 400mg"
                "Emitricitabine 200mg",
                "Tenofovir 300mg",
                "Indinavir 400mg",
                "Saquinavir 200mg")
left JOIN visit v on v.patient_id = pa.patient_id /*for getting Date Last Seen*/
LEFT join patient_identifier pi on pa.patient_id = pi.patient_id and pi.identifier_type in (select patient_identifier_type_id from patient_identifier_type where name = 'PREP/OI Identifier' and retired=0 and uniqueness_behavior = 'UNIQUE')
LEFT JOIN patient_identifier piu on pa.patient_id = piu.patient_id and piu.identifier_type in (select patient_identifier_type_id from patient_identifier_type where name = 'UIC' and retired=0 )
LEFT JOIN person p on pa.patient_id = p.person_id
LEFT JOIN person_name pn on pa.patient_id = pn.person_id
LEFT JOIN person_attribute pac on pa.patient_id = pac.person_id
LEFT JOIN person_attribute_type pat on pac.person_attribute_type_id = pat.person_attribute_type_id
LEFT jOIN concept_view cv1 on pac.value = cv1.concept_id AND cv1.retired = 0

group by pai.patient_id having datediff('#endDate#', date(max(pai.start_date_time))) >= 7 AND datediff('#endDate#', date(max(pai.start_date_time))) <= 89
order by date(max(pai.start_date_time));
