set @concept_id = 0;
set @concept_short_id = 0;
set @concept_full_id = 0;
set @count = 0;
set @uuid = NULL;

call add_concept_psi(@concept_id,@concept_short_id,@concept_full_id,"FP Cont Form, Temperature",'Temp','Numeric','Misc',false);
call add_concept_psi(@concept_id,@concept_short_id,@concept_full_id,"FP Cont Form, State COC Cycles",'State COC Cycles','Numeric','Misc',false);
call add_concept_psi(@concept_id,@concept_short_id,@concept_full_id,"FP Cont Form, State POP Cycles",'State POP Cycles','Numeric','Misc',false);
call add_concept_psi(@concept_id,@concept_short_id,@concept_full_id,"FP Cont Form, Start of procedure indicate time",'Start of procedure indicate time','Text','Misc',false);
call add_concept_psi(@concept_id,@concept_short_id,@concept_full_id,"FP Cont Form, End of procedure indicate time",'End of procedure indicate time','Text','Misc',false);
call add_concept_psi(@concept_id,@concept_short_id,@concept_full_id,"FP Initial Form, State Procedure",'State Procedure','Coded','Misc',false);
call add_concept_psi(@concept_id,@concept_short_id,@concept_full_id,"FP Cont Form, Removal Method",'Removal Method','Coded','Misc',false);
call add_concept_psi(@concept_id,@concept_short_id,@concept_full_id,"FP Cont Form, State reason for removal",'State reason for removal','Coded','Misc',false);
call add_concept_psi(@concept_id,@concept_short_id,@concept_full_id,"FP Init Form, Insertion Method",'Insertion Method','Coded','Misc',false);
call add_concept_psi(@concept_id,@concept_short_id,@concept_full_id,"FP Init Form, Removal Method",'Removal Method','Coded','Misc',false);
call add_concept_psi(@concept_id,@concept_short_id,@concept_full_id,"FP Init Form, State reason for removal",'State reason for removal','Coded','Misc',false);
call add_concept_psi(@concept_id,@concept_short_id,@concept_full_id,"FP Init Form, Insert/Remove Removal Method",'Removal Method','Coded','Misc',false);
call add_concept_psi(@concept_id,@concept_short_id,@concept_full_id,"FP Init Form, InsertRemove state reason for removal",'State reason for removal','Coded','Misc',false);
call add_concept_psi(@concept_id,@concept_short_id,@concept_full_id,"FP Init Form, Insert/Remove Insertion Method",'Insertion Method','Coded','Misc',false);
call add_concept_psi(@concept_id,@concept_short_id,@concept_full_id,"FP Cont Form, Insert/Remove State HealthConcernComplication",'State the health concerns and complications','Coded','Misc',false);
call add_concept_psi(@concept_id,@concept_short_id,@concept_full_id,"FP Cont Form, Insert/Remove Side effect Specify details",'If side effects, specify details','Text','Misc',false);
call add_concept_psi(@concept_id,@concept_short_id,@concept_full_id,"FP Init Form, Insert/Remove State HealthConcernComplication",'State the health concerns and complications','Coded','Misc',false);
call add_concept_psi(@concept_id,@concept_short_id,@concept_full_id,"FP Init Form, Insert/Remove Side effect Specify details",'If side effects, specify details','Text','Misc',false);
call add_concept_psi(@concept_id,@concept_short_id,@concept_full_id,"FP Init Form, Removal Method State HealthConcernComplication",'State the health concerns and complications','Coded','Misc',false);
call add_concept_psi(@concept_id,@concept_short_id,@concept_full_id,"FP Init Form, Removal Method Side effect Specify details",'If side effects, specify details','Text','Misc',false);