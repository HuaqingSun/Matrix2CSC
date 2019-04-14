% function [ Value,RowRelativeIndex,ColumnOffset ] = Matrix2CSC( Imatrix )
%% Matrix2CSC designed by Aki.
%% input a matrix,and output CRC arrays.use relative addressing,and output a zero when count 15 continuous zeros.
%% illustrated by examples
%% example 1
% 			Imatrix   =		  [111    98     5     0     0;
% 							   174     0     0     0     0;
% 								 0     1     0     6     0;
% 								 0     0     0     0     0;
% 								31    60     0     4     0;
% 								96    17     0     1     0;
% 								81     0     0     2     0;
% 							   188   221     0     3     0;
% 								 0     8     0     4     0;
% 								 0     0     0     5     0;
% 								 0     1     0     6     0;
% 								 0     0     0     8     0;
% 								 0     0     0     0     0;
% 								11     0     0     2     0;
% 								 0     0     0     6     0;
% 								 0     0     0     9     0;
% 								 0     0     0     1     0;
% 								11     0     0     4     0;
% 								23     0     0     2     0;
% 								59     0     0     5     0;
% 								 0     0     0     5     0;
% 								 0     0     0     0     1;
% 								 2     0     0     0     1;
% 							   111     0     0     0     0;
% 								 0     0     4     1     0;
% 								 4     0     0     3     0;
% 								66     0     0    90     0;
% 								71    21     3     0     0;
% 								 0     0     9     0     0;
% 								 1     0     0     3     0;
% 								 0     0     0     0     0;
% 								 0     4     2     0     5];
%% Value            = [111 174 31 96 81 188 11 11 23 59 2  111 4  66 71 1     98 1 60 17 221 8 1  0  21 4      5 0  4  3   9  2     6 4 1 2 3 4 5 6  8  2  6  9  1  4  2  5  5  1  3  90 3     0  1  1  5 ];
%% RowIndex         = [0   1   4  5  6   7  13 17 18 19 22 23  25 26 27 29    0  2 4  5  7   8 10 15 27 31     0 15 24 27  28 31    2 4 5 6 7 8 9 10 11 13 14 15 16 17 18 19 20 24 25 26 29   15 21 22 31];
%% RowRelativeIndex = [0,  1,  3, 1, 1,  1, 6, 4, 1, 1, 3, 1,  2, 1, 1, 2,    0, 2,2, 1, 2,  1,2, 5, 12,4,     0,15,9, 3,  1, 3,    2,2,1,1,1,1,1,1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 4, 1, 1, 3,   15,6, 1, 9];
%% ColumnOffset     = [0   16  26 32 53  57];%��ƫ�Ʊ�ʾĳһ�еĵ�һ��Ԫ����values�������ʼƫ��λ�á�
%% end
%% example 2
% %                 Imatrix = [ 1 7 0 0;
% %                             0 2 8 0;
% %                             5 0 3 9;
% %                             0 6 0 4];
%% Value        = [1 5 7 2 6 8 3 9 4];//12 bit first
%% RowIndex     = [0 2 0 1 3 1 2 2 3];
%% RowRealtiveIndex = [0 2 0 1 2 1 1 2 1];//4 bit next
%% ColumnOffset = [0 2 5 7 9];//ָ�� 12 

					 							 
    [RowNum,ColumnNum]      = size(Imatrix)         		;
    Num                     = RowNum    *  ColumnNum    	;%��������Ĵ�С
    CntZero                 = 0                     		;%��0����
    CntCol                  = 0                     		;%�м���
    Value                   = 0                     		;%��ֵ
    RowIndex                = 0                     		;%������
    ColumnOffset            = 0                     		;%��ƫ��
    j                       = 0                     		;
    k                       = 1                     		;
    m                       = 0                             ;
    n                       = 0                     		;				
for i = 1:Num		
    if 	Imatrix(i) ~= 0		
        n                   = n         +       1      		;%�������ֵ�Ƿ�0ֵʱ �洢��ֵ ÿ���Ĵ�����index
        CntCol              = CntCol    +       1      		;%�м��� ��1
        Value(n)            = Imatrix(i)            		;%�����ʱ��ֵ
		RowIndex(n)         =                   m           ;%�����ʱ��������
		CntZero             = 					0			;%��0���� ��λ0
	else	
		CntZero             = CntZero   +       1			;%�������ֵ��0ֵʱ ���洢��ʱ��ֵ �Լ������� ����0������ʼ��1
		if CntZero	==   15	                            
		CntZero			    = 					0			;%������������15��0ֵʱ ��0������λ
        CntCol              = CntCol    +       1      		;%�м�����1 ��ΪҪ�������0ֵ��
		n					= n	     	+       1		   	;
		Value(n)			= 					0		   	;%����0ֵ
		RowIndex(n)			=  					15		   	;%������ֱ����15
		end	
    end
		j                   = j      	+       1      	   	;
    if 	j == RowNum	
        j                   =                   0    	   	;% j�Ƕ�һ�е����ݽ��м��� 
        k                   = k      	+       1      	   	;% k����ƫ�Ƶľ��������
        ColumnOffset(k)     = CntCol 	+ ColumnOffset(k-1)	;% ��ƫ���Ǽ���ǰһ�з�0���ݵĸ��������ʱ�ľ�����
        CntCol              =                   0           ;
    end
    if  m == (RowNum-1) %������ ��־���Ƿ��������ȫ����ѡ����� ��ȫ�������ʺ� ��λ0 ������������ ����
            m = 0;
    else
        m = m + 1;
    end
end

for ll = 1:ColumnNum
	ValidNum(ll) = ColumnOffset(ll+1) - ColumnOffset(ll);%������������ƫ�Ƽ����һ���ж��������Ƿ�0ֵ
end

index = 1;
for ll = 1:ColumnNum
	for kk = 1:ValidNum(ll)
		if kk == 1
			RowRelativeIndex(index) = RowIndex(index);%һ�е�һ����ƫ���Ǳ���������
		else                                      
			RowRelativeIndex(index) = RowIndex(index) - RowIndex(index-1);%�������ƫ�ƶ�������ڸ��еĵ�һ����0ֵ����ƫ��
		end
		index = index + 1;
	end
end



% end
    