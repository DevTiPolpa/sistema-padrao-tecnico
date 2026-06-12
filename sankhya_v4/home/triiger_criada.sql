BEGIN
  EXECUTE IMMEDIATE '
    CREATE OR REPLACE TRIGGER TRG_UMIDADE_STATUS
    BEFORE INSERT OR UPDATE OF VALOR_UMIDADE ON AD_ADUMIDADEPRODUTO
    FOR EACH ROW
    DECLARE
      V_STATUS VARCHAR2(1);
    BEGIN
      IF ' || CHR(58) || 'NEW.VALOR_UMIDADE < 18 THEN
        V_STATUS := ' || CHR(39) || '2' || CHR(39) || ';
      ELSIF ' || CHR(58) || 'NEW.VALOR_UMIDADE > 22 THEN
        V_STATUS := ' || CHR(39) || '3' || CHR(39) || ';
      ELSE
        V_STATUS := ' || CHR(39) || '1' || CHR(39) || ';
      END IF;
      ' || CHR(58) || 'NEW.STATUS := V_STATUS;
    END TRG_UMIDADE_STATUS;
  ';
END;
/

BEGIN
  EXECUTE IMMEDIATE '
    CREATE OR REPLACE TRIGGER TRG_CARRINHOS_STATUS_TEMPO
    BEFORE INSERT OR UPDATE ON AD_ADCARRINHOS
    FOR EACH ROW
    DECLARE
      V_STATUS VARCHAR2(1);
      V_TEMPO  NUMBER;
    BEGIN
      IF ' || CHR(58) || 'NEW.DATA_SAIDA IS NOT NULL THEN
        V_TEMPO := ROUND((' || CHR(58) || 'NEW.DATA_SAIDA - ' || CHR(58) || 'NEW.DATA_ENTRADA) * 24, 2);
        IF V_TEMPO < 0 THEN
          V_TEMPO := 0;
        END IF;
        V_STATUS := ' || CHR(39) || '3' || CHR(39) || ';
      ELSE
        V_TEMPO := ROUND((SYSDATE - ' || CHR(58) || 'NEW.DATA_ENTRADA) * 24, 2);
        V_STATUS := NULL;
      END IF;

      ' || CHR(58) || 'NEW.TEMPO := V_TEMPO;
      ' || CHR(58) || 'NEW.STATUS := V_STATUS;
    END TRG_CARRINHOS_STATUS_TEMPO;
  ';
END;
/

BEGIN
  EXECUTE IMMEDIATE '
    CREATE OR REPLACE TRIGGER TRG_CARRINHOS_VALIDA_DATAS
    BEFORE INSERT OR UPDATE ON AD_ADCARRINHOS
    FOR EACH ROW
    DECLARE
      V_DIFF_HORAS NUMBER;
    BEGIN

      -- 1. DATA_ENTRADA nao pode ser inferior ao dia atual (apenas a data, ignora hora)
      IF TRUNC(' || CHR(58) || 'NEW.DATA_ENTRADA) < TRUNC(SYSDATE) THEN
        RAISE_APPLICATION_ERROR(-20001, ' || CHR(39) || 'DATA DE ENTRADA nao pode ser inferior a data atual.' || CHR(39) || ');
      END IF;

      -- 2. DATA_ENTRADA nao pode ser posterior a data/hora atual
      IF ' || CHR(58) || 'NEW.DATA_ENTRADA > SYSDATE THEN
        RAISE_APPLICATION_ERROR(-20002, ' || CHR(39) || 'DATA DE ENTRADA nao pode ser posterior a data e hora atual.' || CHR(39) || ');
      END IF;

      -- 3. DATA_SAIDA so pode ser preenchida se DATA_ENTRADA estiver preenchida
      IF ' || CHR(58) || 'NEW.DATA_SAIDA IS NOT NULL AND ' || CHR(58) || 'NEW.DATA_ENTRADA IS NULL THEN
        RAISE_APPLICATION_ERROR(-20003, ' || CHR(39) || 'DATA DE SAIDA nao pode ser preenchida sem DATA DE ENTRADA.' || CHR(39) || ');
      END IF;

      -- 4. DATA_SAIDA nao pode ser menor que DATA_ENTRADA
      IF ' || CHR(58) || 'NEW.DATA_SAIDA IS NOT NULL AND ' || CHR(58) || 'NEW.DATA_SAIDA < ' || CHR(58) || 'NEW.DATA_ENTRADA THEN
        RAISE_APPLICATION_ERROR(-20004, ' || CHR(39) || 'DATA DE SAIDA nao pode ser menor que DATA DE ENTRADA.' || CHR(39) || ');
      END IF;

      -- 5. DATA_SAIDA nao pode ser igual a DATA_ENTRADA
      IF ' || CHR(58) || 'NEW.DATA_SAIDA IS NOT NULL AND ' || CHR(58) || 'NEW.DATA_SAIDA = ' || CHR(58) || 'NEW.DATA_ENTRADA THEN
        RAISE_APPLICATION_ERROR(-20005, ' || CHR(39) || 'DATA DE SAIDA nao pode ser igual a DATA DE ENTRADA.' || CHR(39) || ');
      END IF;

      -- 6. Diferenca minima de 16 horas entre DATA_ENTRADA e DATA_SAIDA
      IF ' || CHR(58) || 'NEW.DATA_SAIDA IS NOT NULL THEN
        V_DIFF_HORAS := (' || CHR(58) || 'NEW.DATA_SAIDA - ' || CHR(58) || 'NEW.DATA_ENTRADA) * 24;
        IF V_DIFF_HORAS < 16 THEN
          RAISE_APPLICATION_ERROR(-20006, ' || CHR(39) || 'A diferenca entre DATA DE ENTRADA e DATA DE SAIDA deve ser de no minimo 16 horas.' || CHR(39) || ');
        END IF;
      END IF;

    END TRG_CARRINHOS_VALIDA_DATAS;
  ';
END;
/


CREATE OR REPLACE TRIGGER TRG_UMIDADE_STATUS
    BEFORE INSERT OR UPDATE OF VALOR_UMIDADE ON AD_ADUMIDADEPRODUTO
    FOR EACH ROW
    DECLARE
      V_STATUS VARCHAR2(1);
    BEGIN
      IF :NEW.VALOR_UMIDADE < 18 THEN
        V_STATUS := '2';
      ELSIF :NEW.VALOR_UMIDADE > 22 THEN
        V_STATUS := '3';
      ELSE
        V_STATUS := '1';
      END IF;
      :NEW.STATUS := V_STATUS;
    END TRG_UMIDADE_STATUS;
/

CREATE OR REPLACE TRIGGER TRG_CARRINHOS_STATUS_TEMPO
    BEFORE INSERT OR UPDATE ON AD_ADCARRINHOS
    FOR EACH ROW
    DECLARE
      V_STATUS VARCHAR2(1);
      V_TEMPO  NUMBER;
    BEGIN
      IF :NEW.DATA_SAIDA IS NOT NULL THEN
        V_TEMPO := ROUND((:NEW.DATA_SAIDA - :NEW.DATA_ENTRADA) * 24, 2);
        IF V_TEMPO < 0 THEN
          V_TEMPO := 0;
        END IF;
        V_STATUS := '3';
      ELSE
        V_TEMPO := ROUND((SYSDATE - :NEW.DATA_ENTRADA) * 24, 2);
        V_STATUS := NULL;
      END IF;

      :NEW.TEMPO := V_TEMPO;
      :NEW.STATUS := V_STATUS;
    END TRG_CARRINHOS_STATUS_TEMPO;
  
/


CREATE OR REPLACE TRIGGER TRG_CARRINHOS_VALIDA_DATAS
    BEFORE INSERT OR UPDATE ON AD_ADCARRINHOS
    FOR EACH ROW
    DECLARE
      V_DIFF_HORAS NUMBER;
    BEGIN

      -- 1. DATA_ENTRADA nao pode ser inferior ao dia atual (apenas a data, ignora hora)
      IF TRUNC(:NEW.DATA_ENTRADA) < TRUNC(SYSDATE) THEN
        RAISE_APPLICATION_ERROR(-20001, 'DATA DE ENTRADA nao pode ser inferior a data atual.');
      END IF;

      -- 2. DATA_ENTRADA nao pode ser posterior a data/hora atual
      IF :NEW.DATA_ENTRADA > SYSDATE THEN
        RAISE_APPLICATION_ERROR(-20002, 'DATA DE ENTRADA nao pode ser posterior a data e hora atual.');
      END IF;

      -- 3. DATA_SAIDA so pode ser preenchida se DATA_ENTRADA estiver preenchida
      IF :NEW.DATA_SAIDA IS NOT NULL AND :NEW.DATA_ENTRADA IS NULL THEN
        RAISE_APPLICATION_ERROR(-20003, 'DATA DE SAIDA nao pode ser preenchida sem DATA DE ENTRADA.');
      END IF;

      -- 4. DATA_SAIDA nao pode ser menor que DATA_ENTRADA
      IF :NEW.DATA_SAIDA IS NOT NULL AND :NEW.DATA_SAIDA < :NEW.DATA_ENTRADA THEN
        RAISE_APPLICATION_ERROR(-20004, 'DATA DE SAIDA nao pode ser menor que DATA DE ENTRADA.');
      END IF;

      -- 5. DATA_SAIDA nao pode ser igual a DATA_ENTRADA
      IF :NEW.DATA_SAIDA IS NOT NULL AND :NEW.DATA_SAIDA = :NEW.DATA_ENTRADA THEN
        RAISE_APPLICATION_ERROR(-20005, 'DATA DE SAIDA nao pode ser igual a DATA DE ENTRADA.');
      END IF;

      -- 6. Diferenca minima de 16 horas entre DATA_ENTRADA e DATA_SAIDA
      IF :NEW.DATA_SAIDA IS NOT NULL THEN
        V_DIFF_HORAS := (:NEW.DATA_SAIDA - :NEW.DATA_ENTRADA) * 24;
        IF V_DIFF_HORAS < 16 THEN
          RAISE_APPLICATION_ERROR(-20006, 'A diferenca entre DATA DE ENTRADA e DATA DE SAIDA deve ser de no minimo 16 horas.');
        END IF;
      END IF;

    END TRG_CARRINHOS_VALIDA_DATAS;
  
/