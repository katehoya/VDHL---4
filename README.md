## 주제 소개
  본 프로젝트의 주제는 같은 이동통신망에서 기지국 사이에서 발생하는 handover의 구현이다.
  handover는 단말기가 연결된 기지국의 서비스 공간에서 다른 기지국의 서비스 공간으로 이동할 때, 단말기가 다른 기지국의 서비스 공간에 할당한 통화 채널에 동조하여 서비스가 연결되는 기능이다.
  ![image](https://github.com/user-attachments/assets/4170c6eb-e953-437d-90c8-2d9711bb1a29)
![image](https://github.com/user-attachments/assets/408eb69b-02e4-4da7-bf81-cf9b38cc45e6)
설계한 handover 시스템을 block diagram으로 나타내면 다음과 같다(편의상 DMUX는 생략하였다).
Server -> BaseStation1 -> Mobile Device로 데이터를 받다가 Mobile Device에서 signal quality가 낮아진 것을 판단하면 BaseStation1에서 Mobile Device로 target request 신호를 보내 Mobile Device에서 가장 signal quality가 큰 BaseStation을 찾는다.
찾은 BaseStation의 번호(이 경우 번호는 2이다)를 다시 BaseStation1으로 보내면 BaseStation1에서 BaseStation2로 handover request를 보낸다.
![image](https://github.com/user-attachments/assets/2459e6a8-ff0c-47f4-8227-745006d0be5b)
BaseStation2에서 handover request를 받으면 Server와 Mobile Device가 BaseStation2와 연결되고 이제 Server -> BaseStation2 -> Mobile Device로 데이터가 이동하게 된다.

## testbench 결과
![image](https://github.com/user-attachments/assets/e21a3f70-1ad6-404e-8345-14532e9a5693)
BaseStation2가 Source인 상황에서 BaseStation2의 signal quality가 50 이하이므로 state가 CHECK_SQ -> Newtarget_Info_to_BS -> Newtarget_Info_to_SV -> IDLE로 변하고,이때 BaseStation1의 signal quality가 60으로 가장 크므로 state가 IDLE -> Target_state -> Source로 변하는 것을 볼 수 있다. 
또한 SV_data가 초반에 0011로 주어지고 있는데 BaseStation2가 Source일 때는 Server에서 BaseStation2, MD_DMUX를 통해 final_data로 0011이 출력되지만 handover 이후의 상황에서 BaseStation2의 출력은 x가 되고 BaseStation1, MD_DMUX를 통해 final_data로 출력되는 것을 알 수 있다.
SV_data를 0000으로 바꿔 입력해도 결과는 동일했다.

## oasys 합성 및 면적 측정
![image](https://github.com/user-attachments/assets/6bbd5803-1137-4b51-bd8e-0740fb7f5d30)
<BS1, BS2, BS3와 i_0(server, MD_DMUX, mobiledevice)의 회로도>
![image](https://github.com/user-attachments/assets/1c6084aa-2c68-494c-a122-6e3b07f7382b)
<i_0(server, MD_DMUX, mobiledevice)의 회로도>
![image](https://github.com/user-attachments/assets/f05b41fd-4945-42ca-82e1-87e00ff19a63)
<각 모듈의 면적 측정(단위 :)>
oasys로 합성한 전체 회로도와 면적 결과이다. 설계한 의도대로 각 모듈끼리 input 및 output 신호의 연결이 잘 되어 있는 것을 볼 수 있고 면적의 경우 표로 다시 정리하면 다음과 같다
![image](https://github.com/user-attachments/assets/b642432b-cfe7-4513-ab20-3a34329679e7)
각 모듈의 면적은 1mm 제한의 조건을 충족하고 전체 면적의 경우 계산하면 0.047739mm이다.
