            
		            INCLUDE 'MC9S08JM16.inc'
		            
		            XDEF _Startup
		            ABSENTRY _Startup
                  
     		ORG     0B0H  ; RAM origin
var_delay DS.B   2
segundos DS.B 1 ; for clock
minutos DS.B 1
horas DS.B 1
dias DS.B 1
alarm_minutos DS.B 1 ; FOR WAKE UP TIME
alarm_horas DS.B 1
alarm_dias DS.B 1     
temporal DS.B 1   
selector DS.B 1    
            
            ORG    0C000H ; Flash origin
            
_Startup:
					CLRA 
		           	STA SOPT1 				; disenabling watchdog
		            LDHX   #RAMEnd+1        ; initialize the stack pointer
		            TXS	

main:
					JSR initial_config
					JSR initial_states	
					JSR init_IRQ  ; Just for set the initial time, and clock
					JMP *
					
start_clock:		JSR init_RTC
					JMP *	            
				    BRA main
;************************************************************************INITIAL CONFIGURATION SUBROUTINE
initial_config:
					MOV #255,PTBDD ; Setting data direction (OUT)
					MOV #255,PTCDD
					MOV #255,PTDDD
					MOV #255,PTEDD
					MOV #255,PTFDD
					MOV #255,PTGDD				
					RTS
;************************************************************************INITIAL STATES SUBROUTINE					
initial_states:					
					MOV #0,PTBD ;| 4 1/2 STATIC LCD OFF
					MOV #0,PTCD ;|
					MOV #0,PTDD ;|
					MOV #0,PTED ;|
					MOV #0,PTFD ;|
					MOV #0,PTGD ;|
					MOV #0,segundos        ;| Setting initial time
					MOV #0,minutos		   ;|	
					MOV #0,horas           ;|
					MOV #0,dias			   ;|
					MOV #0,alarm_minutos   ;|
					MOV #0,alarm_horas     ;|
					MOV #0,alarm_dias	   ;|
					MOV #0,selector
					JSR show_time
					RTS
;********************************************************************Subroutine for initialize IRQ
init_IRQ:
			MOV #01010100B,IRQSC ; ACK clearing flag
			BSET IRQSC_IRQIE,IRQSC ; Enabling interrupt
			CLI
			RTS		
								
;***********************************************************************************Init RTC					
init_RTC:
					MOV #0H,RTCMOD
					MOV #1FH,RTCSC
					CLI
					RTS			
				
;***********************************************************************************THOUSAND TABLE
mil_0:
					BSET 0,PTCD  ; A
					BSET 5,PTGD  ; B
					BSET 1,PTFD  ; C
					BSET 0,PTFD  ; D 
					BSET 4,PTCD  ; E
					BSET 1,PTCD  ; F
					BCLR 2,PTCD  ; G 
					RTS
mil_1:
					BCLR 0,PTCD  ; A
					BSET 5,PTGD  ; B
					BSET 1,PTFD  ; C
					BCLR 0,PTFD  ; D 
					BCLR 4,PTCD  ; E
					BCLR 1,PTCD  ; F
					BCLR 2,PTCD  ; G 
					RTS
mil_2:
					BSET 0,PTCD  ; A
					BSET 5,PTGD  ; B
					BCLR 1,PTFD  ; C
					BSET 0,PTFD  ; D 
					BSET 4,PTCD  ; E
					BCLR 1,PTCD  ; F
					BSET 2,PTCD  ; G 
					RTS
mil_3:
					BSET 0,PTCD  ; A
					BSET 5,PTGD  ; B
					BSET 1,PTFD  ; C
					BSET 0,PTFD  ; D 
					BCLR 4,PTCD  ; E
					BCLR 1,PTCD  ; F
					BSET 2,PTCD  ; G 
					RTS
mil_4:
					BCLR 0,PTCD  ; A
					BSET 5,PTGD  ; B
					BSET 1,PTFD  ; C
					BCLR 0,PTFD  ; D 
					BCLR 4,PTCD  ; E
					BSET 1,PTCD  ; F
					BSET 2,PTCD  ; G 
					RTS
mil_5:
					BSET 0,PTCD  ; A
					BCLR 5,PTGD  ; B
					BSET 1,PTFD  ; C
					BSET 0,PTFD  ; D 
					BCLR 4,PTCD  ; E
					BSET 1,PTCD  ; F
					BSET 2,PTCD  ; G 
					RTS
mil_6:
					BCLR 0,PTCD  ; A
					BCLR 5,PTGD  ; B
					BSET 1,PTFD  ; C
					BSET 0,PTFD  ; D 
					BSET 4,PTCD  ; E
					BSET 1,PTCD  ; F
					BSET 2,PTCD  ; G 
					RTS
mil_7:
					BSET 0,PTCD  ; A
					BSET 5,PTGD  ; B
					BSET 1,PTFD  ; C
					BCLR 0,PTFD  ; D 
					BCLR 4,PTCD  ; E
					BCLR 1,PTCD  ; F
					BCLR 2,PTCD  ; G 
					RTS
mil_8:
					BSET 0,PTCD  ; A
					BSET 5,PTGD  ; B
					BSET 1,PTFD  ; C
					BSET 0,PTFD  ; D 
					BSET 4,PTCD  ; E
					BSET 1,PTCD  ; F
					BSET 2,PTCD  ; G 
					RTS
mil_9:			
					BSET 0,PTCD  ; A
					BSET 5,PTGD  ; B
					BSET 1,PTFD  ; C
					BCLR 0,PTFD  ; D 
					BCLR 4,PTCD  ; E
					BSET 1,PTCD  ; F
					BSET 2,PTCD  ; G 	
					RTS
								
;***********************************************************************************HUNDREDS TABLE					
centenas_0:
					BSET 2,PTGD  ; A
					BSET 1,PTGD  ; B
					BSET 0,PTED  ; C
					BSET 5,PTFD  ; D 
					BSET 4,PTFD  ; E
					BSET 3,PTGD  ; F
					BCLR 4,PTGD  ; G 
					RTS
centenas_1:
					BCLR 2,PTGD  ; A
					BSET 1,PTGD  ; B
					BSET 0,PTED  ; C
					BCLR 5,PTFD  ; D 
					BCLR 4,PTFD  ; E
					BCLR 3,PTGD  ; F
					BCLR 4,PTGD  ; G 
					RTS
centenas_2:
					BSET 2,PTGD  ; A
					BSET 1,PTGD  ; B
					BCLR 0,PTED  ; C
					BSET 5,PTFD  ; D 
					BSET 4,PTFD  ; E
					BCLR 3,PTGD  ; F
					BSET 4,PTGD  ; G 
					RTS
centenas_3:
					BSET 2,PTGD  ; A
					BSET 1,PTGD  ; B
					BSET 0,PTED  ; C
					BSET 5,PTFD  ; D 
					BCLR 4,PTFD  ; E
					BCLR 3,PTGD  ; F
					BSET 4,PTGD  ; G 
					RTS
centenas_4:
					BCLR 2,PTGD  ; A
					BSET 1,PTGD  ; B
					BSET 0,PTED  ; C
					BCLR 5,PTFD  ; D 
					BCLR 4,PTFD  ; E
					BSET 3,PTGD  ; F
					BSET 4,PTGD  ; G 
					RTS
centenas_5:
					BSET 2,PTGD  ; A
					BCLR 1,PTGD  ; B
					BSET 0,PTED  ; C
					BSET 5,PTFD  ; D 
					BCLR 4,PTFD  ; E
					BSET 3,PTGD  ; F
					BSET 4,PTGD  ; G 
					RTS
centenas_6:
					BCLR 2,PTGD  ; A
					BCLR 1,PTGD  ; B
					BSET 0,PTED  ; C
					BSET 5,PTFD  ; D 
					BSET 4,PTFD  ; E
					BSET 3,PTGD  ; F
					BSET 4,PTGD  ; G 
					RTS
centenas_7:
					BSET 2,PTGD  ; A
					BSET 1,PTGD  ; B
					BSET 0,PTED  ; C
					BCLR 5,PTFD  ; D 
					BCLR 4,PTFD  ; E
					BCLR 3,PTGD  ; F
					BCLR 4,PTGD  ; G 
					RTS
centenas_8:
					BSET 2,PTGD  ; A
					BSET 1,PTGD  ; B
					BSET 0,PTED  ; C
					BSET 5,PTFD  ; D 
					BSET 4,PTFD  ; E
					BSET 3,PTGD  ; F
					BSET 4,PTGD  ; G 
					RTS					
centenas_9:
					BSET 2,PTGD  ; A
					BSET 1,PTGD  ; B
					BSET 0,PTED  ; C
					BCLR 5,PTFD  ; D 
					BCLR 4,PTFD  ; E
					BSET 3,PTGD  ; F
					BSET 4,PTGD  ; G 					
					RTS
					
;***********************************************************************************TENS TABLE
decenas_0:	
					BSET 4,PTBD  ; A
					BSET 3,PTBD  ; B
					BSET 3,PTED  ; C
					BSET 2,PTED  ; D 
					BSET 1,PTED  ; E
					BSET 5,PTBD  ; F
					BCLR 0,PTGD  ; G 
					RTS
decenas_1:
					BCLR 4,PTBD  ; A
					BSET 3,PTBD  ; B
					BSET 3,PTED  ; C
					BCLR 2,PTED  ; D 
					BCLR 1,PTED  ; E
					BCLR 5,PTBD  ; F
					BCLR 0,PTGD  ; G 
					RTS
decenas_2:
					BSET 4,PTBD  ; A
					BSET 3,PTBD  ; B
					BCLR 3,PTED  ; C
					BSET 2,PTED  ; D 
					BSET 1,PTED  ; E
					BCLR 5,PTBD  ; F
					BSET 0,PTGD  ; G 
					RTS
decenas_3:
					BSET 4,PTBD  ; A
					BSET 3,PTBD  ; B
					BSET 3,PTED  ; C
					BSET 2,PTED  ; D 
					BCLR 1,PTED  ; E
					BCLR 5,PTBD  ; F
					BSET 0,PTGD  ; G 
					RTS
decenas_4:
					BCLR 4,PTBD  ; A
					BSET 3,PTBD  ; B
					BSET 3,PTED  ; C
					BCLR 2,PTED  ; D 
					BCLR 1,PTED  ; E
					BSET 5,PTBD  ; F
					BSET 0,PTGD  ; G 
					RTS
decenas_5:
					BSET 4,PTBD  ; A
					BCLR 3,PTBD  ; B
					BSET 3,PTED  ; C
					BSET 2,PTED  ; D 
					BCLR 1,PTED  ; E
					BSET 5,PTBD  ; F
					BSET 0,PTGD  ; G 
					RTS
decenas_6:
					BCLR 4,PTBD  ; A
					BCLR 3,PTBD  ; B
					BSET 3,PTED  ; C
					BSET 2,PTED  ; D 
					BSET 1,PTED  ; E
					BSET 5,PTBD  ; F
					BSET 0,PTGD  ; G 
					RTS
decenas_7:
					BSET 4,PTBD  ; A
					BSET 3,PTBD  ; B
					BSET 3,PTED  ; C
					BCLR 2,PTED  ; D 
					BCLR 1,PTED  ; E
					BCLR 5,PTBD  ; F
					BCLR 0,PTGD  ; G 
					RTS
decenas_8:
					BSET 4,PTBD  ; A
					BSET 3,PTBD  ; B
					BSET 3,PTED  ; C
					BSET 2,PTED  ; D 
					BSET 1,PTED  ; E
					BSET 5,PTBD  ; F
					BSET 0,PTGD  ; G 
					RTS
decenas_9:
					BSET 4,PTBD  ; A
					BSET 3,PTBD  ; B
					BSET 3,PTED  ; C
					BCLR 2,PTED  ; D 
					BCLR 1,PTED  ; E
					BSET 5,PTBD  ; F
					BSET 0,PTGD  ; G 
					RTS
;***********************************************************************************UNITS TABLE
unidades_0:
					BSET 0,PTBD  ; A
					BSET 7,PTED  ; B
					BSET 6,PTED  ; C
					BSET 5,PTED  ; D 
					BSET 4,PTED  ; E
					BSET 1,PTBD  ; F
					BCLR 2,PTBD  ; G 
					RTS		
							    
unidades_1:
					BCLR 0,PTBD  ; A
					BSET 7,PTED  ; B
					BSET 6,PTED  ; C
					BCLR 5,PTED  ; D 
					BCLR 4,PTED  ; E
					BCLR 1,PTBD  ; F
					BCLR 2,PTBD  ; G 
					RTS	
unidades_2:
					BSET 0,PTBD  ; A
					BSET 7,PTED  ; B
					BCLR 6,PTED  ; C
					BSET 5,PTED  ; D 
					BSET 4,PTED  ; E
					BCLR 1,PTBD  ; F
					BSET 2,PTBD  ; G 
					RTS	
unidades_3:
					BSET 0,PTBD  ; A
					BSET 7,PTED  ; B
					BSET 6,PTED  ; C
					BSET 5,PTED  ; D 
					BCLR 4,PTED  ; E
					BCLR 1,PTBD  ; F
					BSET 2,PTBD  ; G 
					RTS	
unidades_4:
					BCLR 0,PTBD  ; A
					BSET 7,PTED  ; B
					BSET 6,PTED  ; C
					BCLR 5,PTED  ; D 
					BCLR 4,PTED  ; E
					BSET 1,PTBD  ; F
					BSET 2,PTBD  ; G 
					RTS	
unidades_5:
					BSET 0,PTBD  ; A
					BCLR 7,PTED  ; B
					BSET 6,PTED  ; C
					BSET 5,PTED  ; D 
					BCLR 4,PTED  ; E
					BSET 1,PTBD  ; F
					BSET 2,PTBD  ; G 
					RTS	
unidades_6:
					BCLR 0,PTBD  ; A
					BCLR 7,PTED  ; B
					BSET 6,PTED  ; C
					BSET 5,PTED  ; D 
					BSET 4,PTED  ; E
					BSET 1,PTBD  ; F
					BSET 2,PTBD  ; G 
					RTS	
unidades_7:
					BSET 0,PTBD  ; A
					BSET 7,PTED  ; B
					BSET 6,PTED  ; C
					BCLR 5,PTED  ; D 
					BCLR 4,PTED  ; E
					BCLR 1,PTBD  ; F
					BCLR 2,PTBD  ; G 
					RTS	
unidades_8:
					BSET 0,PTBD  ; A
					BSET 7,PTED  ; B
					BSET 6,PTED  ; C
					BSET 5,PTED  ; D 
					BSET 4,PTED  ; E
					BSET 1,PTBD  ; F
					BSET 2,PTBD  ; G 
					RTS	
unidades_9:
					BSET 0,PTBD  ; A
					BSET 7,PTED  ; B
					BSET 6,PTED  ; C
					BCLR 5,PTED  ; D 
					BCLR 4,PTED  ; E
					BSET 1,PTBD  ; F
					BSET 2,PTBD  ; G 
					RTS	
				    
;************************************************************************SUBROUTINE FOR DELAY GENERATION
delayAx5ms:			 ; 6 cycles the call of subroutine
					PSHH ; save context H
					PSHX ; save context X
					PSHA ; save context A
					LDA var_delay ;  cycles
delay_2:            LDHX #1387H ; 3 cycles 
delay_1:            AIX #-1 ; 2 cycles
			    	CPHX #0 ; 3 cycles  
					BNE delay_1 ; 3 cycles
					DECA ;1 cycle
					CMP #0 ; 2 cycles
					BNE delay_2  ;3 cycles
					PULA ; restore context A
					PULX ; restore context X
					PULH ; restore context H
					RTS ; 5 cycles	

;**********************************************Interrupt Service routine RTC
Vrtc_ISR:
				   BSET RTCSC_RTIF,RTCSC ; Clearing flag
				   BSET 0,PTDD       ;| 
				   MOV #30D,var_delay;| Blink LED
		      	   JSR delayAx5ms	 ;|	
				   BCLR 0,PTDD		 ;|	
				   
				   JSR compare ; TIME to WAKE UP?
				   LDA segundos					;| 
				   INC segundos					;| Increment seconds
				   LDA #60D					    ;|
				   CBEQ segundos,inc_minutes    ;|
				   JSR show_time
				   RTI	

compare:		   LDA horas
				   CBEQ alarm_horas,cp2
				   RTS
cp2:			   LDA minutos
				   CBEQ alarm_minutos,do_exercise
				   RTS
do_exercise:
				  	MOV #0,PTBD ;| 4 1/2 STATIC LCD OFF
					MOV #0,PTCD ;|
					MOV #0,PTDD ;|
					MOV #0,PTED ;|
					MOV #0,PTFD ;|
					MOV #0,PTGD ;|
					MOV #30,minutos
					LDA minutos
				    JSR separate_time
				    JSR show_minutos
					JMP *				   
								   		  	
inc_minutes:
				   CLR segundos			 ;|
				   INC minutos			 ;| Increment minutes
				   LDA #60D				 ;|
				   CBEQ minutos,inc_hour ;|
				   JSR show_time		 ;|
				   RTI
inc_hour:
				   CLR minutos			 ;|
				   INC horas		     ;| Increment hour
				   LDA #13D				 ;|
				   CBEQ minutos,inc_dias ;|
				   JSR show_time		 ;|
				   RTI
inc_dias:
				   MOV #1D,horas  ;| Increment days
				   INC dias       ;|
				   JSR show_time
				   RTI	
show_time:    
				   LDA horas
				   JSR separate_time
				   JSR show_horas
				   LDA minutos
				   JSR separate_time
				   JSR show_minutos
				   RTS
show_alarm:    
				   LDA alarm_horas
				   JSR separate_time
				   JSR show_horas
				   LDA alarm_minutos
				   JSR separate_time
				   JSR show_minutos
				   RTS
				   			  
separate_time:			  
				   LDHX #0000H
				   LDX #10D
				   DIV
				   PSHH
				   PULX
				   STX temporal
				   RTS

show_horas:
				   CBEQA #0,sm_0
				   CBEQA #1,sm_1
				   CBEQA #2,sm_2
				   CBEQA #3,sm_3
				   CBEQA #4,sm_4
				   CBEQA #5,sm_5
				   CBEQA #6,sm_6
				   CBEQA #7,sm_7
				   CBEQA #8,sm_8
				   CBEQA #9,sm_9
				   JMP *
				   
sm_0:   		   JSR mil_0
				   JMP sh_uh
sm_1:   		   JSR mil_1
				   JMP sh_uh
sm_2:   		   JSR mil_2
				   JMP sh_uh
sm_3:   		   JSR mil_3
				   JMP sh_uh
sm_4:   		   JSR mil_4
				   JMP sh_uh
sm_5:   		   JSR mil_5
				   JMP sh_uh
sm_6:   		   JSR mil_6
				   JMP sh_uh
sm_7:   		   JSR mil_7
				   JMP sh_uh
sm_8:   		   JSR mil_8
				   JMP sh_uh
sm_9:   		   JSR mil_9
				   JMP sh_uh
				   
sh_uh:			   LDA temporal ; REMAINDER
				   CBEQA #0,sc_0
				   CBEQA #1,sc_1
				   CBEQA #2,sc_2
				   CBEQA #3,sc_3
				   CBEQA #4,sc_4
				   CBEQA #5,sc_5
				   CBEQA #6,sc_6
				   CBEQA #7,sc_7
				   CBEQA #8,sc_8
				   CBEQA #9,sc_9
				   JMP *

sc_0:   		   JSR centenas_0
				   RTS
sc_1:   		   JSR centenas_1
				   RTS
sc_2:   		   JSR centenas_2
				   RTS
sc_3:   		   JSR centenas_3
				   RTS
sc_4:   		   JSR centenas_4
				   RTS
sc_5:   		   JSR centenas_5
				   RTS
sc_6:   		   JSR centenas_6
				   RTS
sc_7:   		   JSR centenas_7
				   RTS
sc_8:   		   JSR centenas_8
				   RTS
sc_9:   		   JSR centenas_9
				   RTS
				   
show_minutos:  ; Semantic 
				   CBEQA #0,sd_0
				   CBEQA #1,sd_1
				   CBEQA #2,sd_2
				   CBEQA #3,sd_3
				   CBEQA #4,sd_4
				   CBEQA #5,sd_5
				   CBEQA #6,sd_6
				   CBEQA #7,sd_7
				   CBEQA #8,sd_8
				   CBEQA #9,sd_9
				   JMP *
				   
sd_0:   		   JSR decenas_0
				   JMP sh_um
sd_1:   		   JSR decenas_1
				   JMP sh_um
sd_2:   		   JSR decenas_2
				   JMP sh_um
sd_3:   		   JSR decenas_3
				   JMP sh_um
sd_4:   		   JSR decenas_4
				   JMP sh_um
sd_5:   		   JSR decenas_5
				   JMP sh_um
sd_6:   		   JSR decenas_6
				   JMP sh_um
sd_7:   		   JSR decenas_7
				   JMP sh_um
sd_8:   		   JSR decenas_8
				   JMP sh_um
sd_9:   		   JSR decenas_9
				   JMP sh_um
				   
sh_um:			   LDA temporal ; REMAINDER
				   CBEQA #0,su_0
				   CBEQA #1,su_1
				   CBEQA #2,su_2
				   CBEQA #3,su_3
				   CBEQA #4,su_4
				   CBEQA #5,su_5
				   CBEQA #6,su_6
				   CBEQA #7,su_7
				   CBEQA #8,su_8
				   CBEQA #9,su_9
				   JMP *

su_0:   		   JSR unidades_0
				   RTS
su_1:   		   JSR unidades_1
				   RTS
su_2:   		   JSR unidades_2
				   RTS
su_3:   		   JSR unidades_3
				   RTS
su_4:   		   JSR unidades_4
				   RTS
su_5:   		   JSR unidades_5
				   RTS
su_6:   		   JSR unidades_6
				   RTS
su_7:   		   JSR unidades_7
				   RTS
su_8:   		   JSR unidades_8
				   RTS
su_9:   		   JSR unidades_9
				   RTS
				   ;RTI

;**********************************************************Subroutine to blink the LED
blink_led:		   BSET 0,PTDD       ;| 
				   MOV #30D,var_delay;| Blink LED
		      	   JSR delayAx5ms	 ;|	
				   BCLR 0,PTDD		 ;|
				   MOV #30D,var_delay;| Blink LED
		      	   JSR delayAx5ms	 ;|	
				   RTS
;**********************************************************************Interrupt Service Routine for IRQ pin
ISR_IRQ:
				   JSR blink_led
				   BIH select_config  ;Change?
				   JSR blink_led
				   JSR blink_led
				   INC selector
				   
select_config:     LDA selector
				   CBEQA #0,setting_minutes_c
				   CBEQA #1,setting_hour_c
				   CBEQA #2,setting_minutes_a
				   CBEQA #3,setting_hour_a
				   BRA init_clock				   
				   
				   
setting_minutes_c:	 INC minutos
					 LDA #60D					    
				     CBEQ minutos,clr_minutes
				     BRA end_IRQ
clr_minutes:         CLR minutos
					 BRA end_IRQ
				     
setting_hour_c:      INC horas
					 LDA #13D					    
				     CBEQ horas,clr_hours
				     BRA end_IRQ
clr_hours:           MOV #1,horas
					 BRA end_IRQ
					 				     
setting_minutes_a:	 INC alarm_minutos
					 LDA #60D					    
				     CBEQ alarm_minutos,clr_aminutes
				     JSR show_alarm
				     BRA enda_IRQ
clr_aminutes:        CLR alarm_minutos
					 JSR show_alarm
					 BRA enda_IRQ
					 
setting_hour_a:      INC alarm_horas
					 LDA #13D					    
				     CBEQ alarm_horas,clr_ahours
				     JSR show_alarm
				     BRA enda_IRQ
clr_ahours:          MOV #1,alarm_horas
					 JSR show_alarm
					 BRA enda_IRQ
					 	
end_IRQ:
				  	 JSR show_time     ;| Display time 
enda_IRQ:		   	 BSET 2,IRQSC ; clearing flag 
				     RTI	    	

init_clock:   		BCLR IRQSC_IRQIE,IRQSC ; Disenabling IRQ interrupt
					PULA ; Throw CCR away
					PULA ; Throw A away
					PULA ; Throw X away
					PULA ; Throw PCH away 
					PULA ; Throw PCL away
					LDHX #start_clock ; New address after interrupt
					PSHX  
					PSHH
					CLRA
					PSHA
					PSHA
					PSHA
					BRA enda_IRQ				   	    
;***********************************************************INTERRUPT VECTORS		    						
		            ORG Vreset				; Reset
					DC.W  _Startup		
					ORG Virq				;External interrupt
					DC.W ISR_IRQ	
					ORG Vrtc 				; RTC
					DC.W Vrtc_ISR		    
