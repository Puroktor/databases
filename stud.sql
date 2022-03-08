/*
������� 2
*/

SELECT *
FROM STUDENT
WHERE KURS = 1 AND (SYSDATE - BIRTHDAY)/365.25 > 25;

SELECT *
FROM UNIVERSITY
WHERE (CITY = '������' AND RATING < 296);

SELECT *
FROM STUDENT
WHERE CITY IS NULL;

SELECT *
FROM STUDENT
WHERE SURNAME LIKE '�%' OR SURNAME LIKE '�%';

SELECT *
FROM UNIVERSITY
WHERE LOWER(UNIV_NAME) LIKE '%�����������%';

SELECT *
FROM UNIVERSITY
WHERE UNIV_NAME LIKE '_% _% _% _% _% _% _%';

SELECT *
FROM STUDENT
WHERE SURNAME LIKE '___';

SELECT LOWER(SUBSTR(NAME, 0, 1)) ||
'. '||
LOWER(SURNAME) ||
'; ����� ���������� - ' ||
LOWER(CITY) ||
'; �������: ' ||
TO_CHAR(BIRTHDAY, 'DD-mon-YYYY') as text
FROM STUDENT;

SELECT NAME || 
' ' ||
SURNAME ||
' �������(-���) � ' ||
TO_CHAR(BIRTHDAY, 'YYYY') ||
' ����' as text
FROM STUDENT;

SELECT NAME ||
' ' ||
SURNAME ||
' ' ||
100 * STIPEND AS TEXT
FROM STUDENT;

SELECT '���-' ||
UNIV_ID||
'; '||
UNIV_NAME||
' �. ' ||
CITY ||
'; �������=' ||
ROUND(RATING, -2) AS TEXT
FROM UNIVERSITY;

/*
������� 3
*/

SELECT *
FROM STUDENT
WHERE CITY = '�������' AND (STIPEND IS NULL OR STIPEND = 0);

SELECT *
FROM STUDENT
WHERE (SYSDATE - BIRTHDAY)/365.25 < 20;

SELECT UPPER(SUBSTR(NAME, 0, 1)) ||
'. '||
UPPER(SURNAME) ||
'; ����� ���������� - ' ||
UPPER(CITY) ||
'; �������: ' ||
TO_CHAR(BIRTHDAY, 'DD.MM.YY') AS TEXT
FROM STUDENT;

SELECT STUDENT_ID, MAX(MARK)
FROM EXAM_MARKS 
GROUP BY STUDENT_ID;

SELECT MIN(SURNAME)
FROM STUDENT
WHERE SURNAME LIKE '�%';

SELECT TO_CHAR(EXAM_DATE,'DD.MM.YYYY'), COUNT(MARK)
FROM EXAM_MARKS
GROUP BY EXAM_DATE;

SELECT STUDENT_ID, ROUND(AVG(MARK), 3)
FROM EXAM_MARKS
GROUP BY STUDENT_ID;

SELECT UNIV_ID, SUM(STIPEND)
FROM STUDENT 
GROUP BY UNIV_ID
ORDER BY SUM(STIPEND);

SELECT STUDENT_ID, ROUND(AVG(MARK),3)
FROM EXAM_MARKS 
GROUP BY STUDENT_ID;

SELECT UNIV_ID, COUNT(STIPEND)
FROM STUDENT 
GROUP BY UNIV_ID
ORDER BY COUNT(STIPEND);

/*
������� 4
*/

SELECT LOWER(NAME) || 
' ' ||
LOWER(SURNAME) ||
' �������(-���) � ' ||
TO_CHAR(BIRTHDAY, 'YYYY') ||
' ����' AS text
FROM STUDENT
WHERE KURS IN (1,2,4);

SELECT UNIV_ID, COUNT(*)
FROM STUDENT
GROUP BY UNIV_ID
ORDER BY COUNT(*);

SELECT CITY, MAX(RATING)
FROM UNIVERSITY 
GROUP BY CITY
ORDER BY MAX(RATING);

SELECT COUNT(COUNT(STUDENT_ID))
FROM EXAM_MARKS
GROUP BY STUDENT_ID
HAVING MIN(MARK)=5;

SELECT FLOOR(AVG(MARK)),CEIL(AVG(MARK)),ROUND(AVG(MARK)),TRUNC(AVG(MARK))
FROM EXAM_MARKS
GROUP BY EXAM_DATE
ORDER BY 1,2,3,4 DESC;

SELECT *
FROM STUDENT
WHERE STIPEND > (SELECT AVG(STIPEND) FROM STUDENT);

SELECT *
FROM UNIVERSITY
WHERE CITY = '������' AND RATING < 
  (SELECT RATING
  FROM UNIVERSITY
  WHERE UNIV_NAME='����������� ��������������� �����������');
  
/*
�������� ������ 1
*/

--#2.8 �2
SELECT *
  FROM STUDENT, (SELECT AVG(STIPEND) AVG_STIP FROM STUDENT) NEW
  WHERE STIPEND > AVG_STIP;

--#2.8 �6
SELECT * 
FROM UNIVERSITY,
    (SELECT RATING R_VSU
    FROM UNIVERSITY
    WHERE UNIV_NAME='����������� ��������������� �����������') new
WHERE CITY= '������' AND RATING<R_VSU;

--#2.8 �5
SELECT * 
FROM STUDENT ST
WHERE CITY <> 
    (SELECT CITY
    FROM UNIVERSITY UN
    WHERE UN.UNIV_ID = ST.UNIV_ID);
    
--#2.9 �3
SELECT * 
FROM LECTURER LEC
WHERE CITY <> 
    (SELECT CITY
    FROM UNIVERSITY UN
    WHERE UN.UNIV_ID = LEC.UNIV_ID)
ORDER BY UNIV_ID, CITY;

--#2.9 �4
SELECT * 
FROM SUBJECT SUB1
WHERE HOUR = 
    (SELECT MAX(HOUR)
    FROM SUBJECT SUB2
    WHERE SUB1.SEMESTER = SUB2.SEMESTER)
ORDER BY SEMESTER;

--#2.9 �7
SELECT * 
FROM UNIVERSITY UN
WHERE 50<(SELECT COUNT(*)
        FROM STUDENT ST
        WHERE ST.UNIV_ID = UN.UNIV_ID)
ORDER BY RATING;

--#2.9 �9
SELECT * 
FROM STUDENT ST
WHERE 5=(SELECT MIN(MARK)
        FROM EXAM_MARKS EX
        WHERE ST.STUDENT_ID = EX.STUDENT_ID)
ORDER BY UNIV_ID, KURS;

--#2.9 �10
SELECT * 
FROM STUDENT ST
WHERE 2=(SELECT MIN(MARK)
        FROM EXAM_MARKS EX
        WHERE ST.STUDENT_ID = EX.STUDENT_ID)
ORDER BY UNIV_ID, KURS;

--#2.9 �7*
SELECT *
FROM UNIVERSITY U,(SELECT UNIV_ID, COUNT(UNIV_ID) COUNT
        FROM STUDENT GROUP BY UNIV_ID) NEW
WHERE U.UNIV_ID = NEW.UNIV_ID AND COUNT > 50
ORDER BY RATING;

--#2.9 �10*
SELECT UNIV_NAME, COUNT2, COUNT_ALL, RATING
FROM (SELECT UNIV_ID, COUNT(UNIV_ID) COUNT2
        FROM STUDENT S
        WHERE 2=(SELECT MIN(MARK) FROM EXAM_MARKS E
            WHERE S.STUDENT_ID = E.STUDENT_ID)
        GROUP BY UNIV_ID) UNSAT,
    (SELECT UNIV_ID, COUNT(UNIV_ID) COUNT_ALL
        FROM STUDENT
        GROUP BY UNIV_ID) TOTAL,
    UNIVERSITY THIS
WHERE THIS.UNIV_ID = UNSAT.UNIV_ID AND THIS.UNIV_ID = TOTAL.UNIV_ID
ORDER BY RATING;

--#2.10 �4
SELECT COUNT(MARK)
FROM EXAM_MARKS 
WHERE MARK > 2
GROUP BY STUDENT_ID
HAVING COUNT(MARK)>20;

--#2.10 �2
SELECT (SELECT NAME FROM STUDENT S 
    WHERE S.STUDENT_ID = E.STUDENT_ID)
FROM EXAM_MARKS E, (SELECT AVG(MARK) AVG_MARK FROM EXAM_MARKS)
WHERE SUBJ_ID = 101
AND MARK>AVG_MARK;

--#2.10 �6
SELECT NAME, STUDENT_ID
FROM STUDENT
WHERE CITY IS NOT NULL
AND CITY NOT IN (SELECT CITY UNIV_CITIES FROM UNIVERSITY);

--�.�. 1
SELECT * 
FROM STUDENT ST
WHERE CITY = 
    (SELECT CITY
    FROM UNIVERSITY UN
    WHERE UN.UNIV_ID = ST.UNIV_ID);
    
/*
    �.�. � 2
*/

--#2.10 �2
SELECT (SELECT NAME FROM STUDENT S 
    WHERE S.STUDENT_ID = E.STUDENT_ID)
FROM EXAM_MARKS E, (SELECT AVG(MARK) AVG_MARK FROM EXAM_MARKS)
WHERE SUBJ_ID = 101
AND MARK>AVG_MARK;

--#2.10 �3
SELECT (SELECT NAME FROM STUDENT S 
    WHERE S.STUDENT_ID = E.STUDENT_ID)
FROM EXAM_MARKS E, (SELECT AVG(MARK) AVG_MARK FROM EXAM_MARKS)
WHERE SUBJ_ID = 102
AND MARK<AVG_MARK;

--#2.10 �4
SELECT COUNT(MARK)
FROM EXAM_MARKS 
WHERE MARK > 2
GROUP BY STUDENT_ID
HAVING COUNT(MARK)>20;

--#2.11 �3
SELECT *
FROM STUDENT ST
WHERE EXISTS (SELECT * FROM UNIVERSITY UN
    WHERE ST.CITY = UN.CITY
    AND ST.UNIV_ID <> UN.UNIV_ID);
    
--#2.11 �4 
SELECT DISTINCT SUBJ_NAME --�� ����, ����� �� DISTINCT, ��� 2 ���������� c ������� ID
FROM SUBJECT SB
WHERE EXISTS (SELECT * FROM EXAM_MARKS EX
    WHERE SB.SUBJ_ID = EX.SUBJ_ID 
    AND EX.MARK > 2
    GROUP BY EX.SUBJ_ID
    HAVING COUNT(EX.STUDENT_ID) > 1);

--#2.11 �6
SELECT DISTINCT CITY
FROM STUDENT ST
WHERE NOT EXISTS (SELECT * FROM UNIVERSITY
    WHERE CITY=ST.CITY);
    
--#2.11 �9 
SELECT DISTINCT SUBJ_NAME 
FROM SUBJECT SB
WHERE EXISTS (SELECT * FROM SUBJECT
    WHERE SB.SUBJ_NAME=SUBJ_NAME
    AND SB.SEMESTER<>SEMESTER);
    
--#2.11 �14    
SELECT * 
FROM STUDENT ST
WHERE NOT EXISTS (SELECT * FROM EXAM_MARKS
    WHERE ST.STUDENT_ID=STUDENT_ID
    AND MARK<3);
    
--#2.11 �19      
SELECT COUNT(DISTINCT STUDENT_ID)
FROM EXAM_MARKS EX
WHERE NOT EXISTS (SELECT * FROM EXAM_MARKS
    WHERE EX.STUDENT_ID=STUDENT_ID 
    AND MARK<5);
    
/*
    �.�. �3
*/    

--#2.12 �5
SELECT *
FROM SUBJECT
WHERE SUBJ_ID = ANY(
    SELECT SUBJ_ID 
    FROM SUBJ_LECT SL, LECTURER L
    WHERE SL.LECTURER_ID=L.LECTURER_ID
        AND SURNAME = '����������');

--#2.12 �6
SELECT NAME, SURNAME
FROM LECTURER
WHERE LECTURER_ID = ANY(
    SELECT LECTURER_ID 
    FROM SUBJ_LECT SL, SUBJECT S
    WHERE SL.SUBJ_ID=S.SUBJ_ID
        AND SEMESTER IN (1,2));
        
--#2.12 �8
SELECT SURNAME
FROM STUDENT S, UNIVERSITY U
WHERE S.UNIV_ID=U.UNIV_ID
    AND U.CITY <= ALL (SELECT CITY FROM UNIVERSITY
        WHERE CITY IS NOT NULL);
        
--#2.12 �9
SELECT SURNAME
FROM STUDENT S
WHERE 5 = ALL(SELECT MARK FROM EXAM_MARKS E
        WHERE E.STUDENT_ID = S.STUDENT_ID)
    AND CITY<>(SELECT CITY FROM UNIVERSITY
        WHERE UNIV_ID=S.UNIV_ID);
/*
    #2.13 �1
    ��������� �������� �� ����� ������ ����������.
    ����� � �������� MARK ������ NULL.
    ����� ������ ������ ������� ������� �������� ��� ���������,
    � ������ - ���.
*/

--#2.14 �2
SELECT *
FROM STUDENT 
WHERE CITY <> ALL(SELECT CITY FROM UNIVERSITY);

/*
    �.�. �2
*/
SELECT *
FROM SUBJECT, (SELECT MIN(HOUR) MIN_HOUR FROM SUBJECT)
WHERE HOUR = MIN_HOUR;

SELECT SURNAME
FROM STUDENT S
WHERE 5 = ALL(SELECT MARK FROM EXAM_MARKS E
        WHERE E.STUDENT_ID = S.STUDENT_ID)
    AND CITY = (SELECT CITY FROM UNIVERSITY
        WHERE UNIV_ID=S.UNIV_ID);
   
SELECT STUDENT_ID, COUNT(*)
FROM EXAM_MARKS
GROUP BY STUDENT_ID
HAVING COUNT(*)<25;

/*
    �.�. � 4
*/
-- c.60 �1 
SELECT S.UNIV_ID, KURS, COUNT (*)
FROM STUDENT S JOIN UNIVERSITY U
ON S.UNIV_ID = U.UNIV_ID
GROUP BY S.UNIV_ID, KURS;

-- c.60 �6 
SELECT U.UNIV_ID, S.SUBJ_ID, SUM(HOUR)
FROM SUBJECT S JOIN SUBJ_LECT SL
ON S.SUBJ_ID = SL.SUBJ_ID
JOIN LECTURER L
ON SL.LECTURER_ID = L.LECTURER_ID
JOIN UNIVERSITY U
ON L.UNIV_ID = U.UNIV_ID
GROUP BY U.UNIV_ID, S.SUBJ_ID;

-- c.60 �9
SELECT S.UNIV_ID, SURNAME
FROM STUDENT S JOIN UNIVERSITY U
ON S.UNIV_ID=U.UNIV_ID
WHERE BIRTHDAY=(SELECT MAX(BIRTHDAY)
        FROM STUDENT
        WHERE UNIV_ID=U.UNIV_ID);
        
-- c.60 �23
SELECT DISTINCT S.SUBJ_NAME
FROM SUBJECT S JOIN SUBJ_LECT SL
ON S.SUBJ_ID = SL.SUBJ_ID
GROUP BY S.SUBJ_NAME, SL.LECTURER_ID
HAVING 2>=COUNT(SL.LECTURER_ID);

-- c.60 �28
SELECT AVG(HOUR)
FROM SUBJECT S JOIN SUBJ_LECT SL
ON S.SUBJ_ID = SL.SUBJ_ID
JOIN LECTURER L
ON SL.LECTURER_ID = L.LECTURER_ID
JOIN UNIVERSITY U
ON L.UNIV_ID = U.UNIV_ID
WHERE UNIV_NAME = '����������� ��������������� �����������'
    AND SEMESTER IN (3,4);

-- c.60 �29
SELECT S.SURNAME
FROM STUDENT S, (SELECT STUDENT_ID, SEMESTER
    FROM EXAM_MARKS E JOIN SUBJECT S
    ON E.SUBJ_ID=S.SUBJ_ID
    WHERE MARK=5
    GROUP BY STUDENT_ID, SEMESTER
    HAVING COUNT(MARK)>1) SEMS
WHERE S.STUDENT_ID=SEMS.STUDENT_ID
GROUP BY S.SURNAME, KURS
HAVING COUNT(SEMESTER)=2*KURS-1; --������� �� ���������

-- c.63 �4
SELECT S.STUDENT_ID, SUBJ_NAME
FROM STUDENT S LEFT JOIN EXAM_MARKS E
ON S.STUDENT_ID=E.STUDENT_ID
LEFT JOIN SUBJECT SU
ON SU.SUBJ_ID=E.SUBJ_ID;

-- c.63 �8
SELECT S.STUDENT_ID, U.UNIV_NAME
FROM STUDENT S LEFT JOIN UNIVERSITY U
ON S.UNIV_ID=U.UNIV_ID;

SELECT STUDENT_ID, UNIV_ID
FROM STUDENT WHERE UNIV_ID IS NULL;

-- c.63 �15
SELECT E.MARK, S.SUBJ_NAME
FROM EXAM_MARKS E LEFT JOIN SUBJECT S
ON E.SUBJ_ID=S.SUBJ_ID;

SELECT MARK, SUBJ_ID
FROM EXAM_MARKS WHERE SUBJ_ID IS NULL;

/*
    �.�. �5
*/
--#2.15.3 �1
SELECT F.SURNAME, S.SURNAME
FROM STUDENT F, STUDENT S
WHERE F.CITY = S.CITY
    AND F.STUDENT_ID < S.STUDENT_ID;

--#2.15.3 �2
SELECT F.UNIV_NAME, S.UNIV_NAME
FROM UNIVERSITY F, UNIVERSITY S
WHERE F.CITY = S.CITY
    AND F.UNIV_ID < S.UNIV_ID;

--#2.15.3 �3
SELECT F.UNIV_NAME, F.CITY
FROM UNIVERSITY F, UNIVERSITY S
WHERE F.RATING >= S.RATING
    AND S.UNIV_NAME = '����������� ��������������� �����������';    

--#2.15.3 �4    
SELECT DISTINCT F.STUDENT_ID
FROM EXAM_MARKS F, EXAM_MARKS S
WHERE F.MARK = S.MARK
    AND S.STUDENT_ID = 12;
    
--#2.15.3 �5    
SELECT F.LECTURER_ID, S.LECTURER_ID
FROM SUBJ_LECT F, SUBJ_LECT S
WHERE F.SUBJ_ID = S.SUBJ_ID
    AND F.LECTURER_ID < S.LECTURER_ID;
    
/*
    �.�. �6
*/
--#2.16 �1
SELECT UNIV_NAME, CITY, RATING, '������'
    FROM UNIVERSITY
    WHERE RATING < 300
UNION
SELECT UNIV_NAME, CITY, RATING, '�������'
    FROM UNIVERSITY
    WHERE RATING >= 300;

--#2.16 �2
SELECT SURNAME, '��������'
    FROM STUDENT F
    WHERE 3 <= ALL
    (SELECT MARK FROM EXAM_MARKS S
    WHERE F.STUDENT_ID = S.STUDENT_ID)
UNION
    SELECT SURNAME, '�� ��������'
    FROM STUDENT F
    WHERE 2 = ANY (SELECT MARK FROM EXAM_MARKS S
    WHERE F.STUDENT_ID = S.STUDENT_ID)
UNION
    SELECT SURNAME, '�� ������'
    FROM STUDENT F
    WHERE NOT EXISTS (SELECT MARK FROM EXAM_MARKS S
        WHERE F.STUDENT_ID= S.STUDENT_ID)
ORDER BY SURNAME;

--#2.16 �5
SELECT UNIV_NAME, CITY, RATING, 'min'
    FROM UNIVERSITY F
    WHERE RATING = (SELECT MIN(RATING) FROM UNIVERSITY S
        WHERE F.CITY = S.CITY)
UNION
SELECT UNIV_NAME, CITY, RATING, 'max'
    FROM UNIVERSITY F
    WHERE RATING = (SELECT MAX(RATING) FROM UNIVERSITY S
        WHERE F.CITY = S.CITY);
        
--#2.16 �7
SELECT KURS, SURNAME, BIRTHDAY, '�������'
    FROM STUDENT F
    WHERE BIRTHDAY=(SELECT MIN(BIRTHDAY) FROM STUDENT S
        WHERE F.KURS = S.KURS)
UNION
SELECT KURS, SURNAME, BIRTHDAY, 'c������'
    FROM STUDENT F
    WHERE BIRTHDAY=(SELECT MAX(BIRTHDAY) FROM STUDENT S
        WHERE F.KURS = S.KURS);
        
--#2.16 �9
SELECT UNIV_NAME, SURNAME
    FROM UNIVERSITY U JOIN LECTURER L
    ON L.UNIV_ID=U.UNIV_ID
UNION
SELECT UNIV_NAME, '�������������� ���'
    FROM UNIVERSITY U WHERE NOT EXISTS
    (SELECT SURNAME FROM LECTURER L
        WHERE U.UNIV_ID=L.UNIV_ID);

--#2.16 �10
SELECT S.STUDENT_ID, SUBJ_ID, MARK
    FROM STUDENT S JOIN EXAM_MARKS E
    ON S.STUDENT_ID=E.STUDENT_ID
UNION
SELECT S.STUDENT_ID, null, 0
    FROM STUDENT S WHERE NOT EXISTS
    (SELECT MARK FROM EXAM_MARKS E
        WHERE S.STUDENT_ID=E.STUDENT_ID);   

--- �.�. �����������    
SELECT SUBJ_NAME, SURNAME, MARK
FROM SUBJECT SUB JOIN EXAM_MARKS E
    ON SUB.SUBJ_ID = E.SUBJ_ID
JOIN STUDENT S
    ON S.STUDENT_ID = E.STUDENT_ID;
    
SELECT SURNAME, NAME, MARK, SUBJ_NAME
FROM STUDENT S LEFT JOIN EXAM_MARKS E
    ON S.STUDENT_ID = E.STUDENT_ID
LEFT JOIN SUBJECT SUB 
    ON SUB.SUBJ_ID = E.SUBJ_ID;
    
SELECT SURNAME, NAME, MARK, SUBJ_NAME
FROM STUDENT S JOIN EXAM_MARKS E
    ON S.STUDENT_ID = E.STUDENT_ID
JOIN SUBJECT SUB 
    ON SUB.SUBJ_ID = E.SUBJ_ID;

SELECT SURNAME, NAME, SUBJ_NAME, TO_CHAR(MARK)
FROM STUDENT S JOIN EXAM_MARKS E
    ON S.STUDENT_ID = E.STUDENT_ID
JOIN SUBJECT SUB 
    ON SUB.SUBJ_ID = E.SUBJ_ID
UNION    
SELECT SURNAME, NAME, '-', '-'
FROM STUDENT S LEFT JOIN EXAM_MARKS E
    ON S.STUDENT_ID = E.STUDENT_ID
WHERE E.STUDENT_ID IS NULL;

--���. �3
SELECT NAME, SURNAME
FROM LECTURER L JOIN SUBJ_LECT SL
    ON L.LECTURER_ID = SL.LECTURER_ID
JOIN SUBJECT S
    ON SL.SUBJ_ID = S.SUBJ_ID
WHERE SEMESTER IN (1,2);

SELECT UNIV_NAME, SURNAME
FROM UNIVERSITY U LEFT JOIN LECTURER L
    ON U.UNIV_ID = L.UNIV_ID;
    
SELECT UNIV_NAME, NULL
FROM UNIVERSITY U
WHERE NOT EXISTS (SELECT * FROM LECTURER
    WHERE UNIV_ID = U.UNIV_ID);

SELECT UNIV_NAME, SURNAME
FROM UNIVERSITY U JOIN STUDENT S
    ON U.UNIV_ID = S.UNIV_ID
UNION
SELECT UNIV_NAME, '��������� ���'
FROM UNIVERSITY U
WHERE NOT EXISTS (SELECT * FROM STUDENT
    WHERE UNIV_ID=U.UNIV_ID);