<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="UTF-8" isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page import="java.util.*" %>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@ taglib prefix="snk" uri="/WEB-INF/tld/sankhyaUtil.tld" %>

<html>
  <head>
    <title>Carrinhos no Secador</title>
    <snk:load />

    <style>
      body {
        font-family: Arial, sans-serif;
        font-size: 12px;
        margin: 0;
        padding: 8px;
      }

      h3 {
        color: #1f3a5f;
        margin: 0 0 8px 0;
      }

      .painel {
        background: #f4f6f8;
        padding: 10px;
        margin-bottom: 10px;
        border: 1px solid #d0d7de;
      }

      table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 6px;
      }

      th {
        background: #1f3a5f;
        color: #fff;
        padding: 5px;
        text-align: left;
      }

      td {
        padding: 5px;
        border-bottom: 1px solid #e0e0e0;
      }

      input,
      button {
        padding: 4px 8px;
        margin-right: 6px;
      }

      button {
        background: #1f3a5f;
        color: #fff;
        border: 0;
        cursor: pointer;
        padding: 5px 12px;
      }

      /* Status */
      .EM_SECAGEM {
        color: #1565c0;
        font-weight: bold;
      }

      .CONCLUIDO {
        color: #0a7a2a;
        font-weight: bold;
      }

      .ATRASADO {
        color: #c62828;
        font-weight: bold;
      }
      
      /* Cores de Observação */
      .OBS_VERDE {
        color: #0a7a2a;
        font-weight: bold;
      }

      .OBS_LARANJA {
        color: #ef6c00;
        font-weight: bold;
      }

      .OBS_VERMELHO {
        color: #c62828;
        font-weight: bold;
      }

      .OBS_AZUL {
        color: #1565c0;
        font-weight: bold;
      }
    </style>
  </head>

  <body>
    <snk:query var="movimentacoes">
      SELECT
          ID,
          CARRINHO,
          BANDEJAS,
          PESO,

          TO_CHAR(DATA_ENTRADA,'DD/MM/YYYY HH24:MI') AS ENTRADA,
          TO_CHAR(DATA_SAIDA,'DD/MM/YYYY HH24:MI') AS SAIDA,

          CASE 
              WHEN DATA_SAIDA IS NOT NULL AND DATA_SAIDA < DATA_ENTRADA THEN 0
              ELSE ROUND((NVL(DATA_SAIDA, SYSDATE) - DATA_ENTRADA) * 24, 2)
          END AS TEMPO_DECORRIDO,

          CASE
              WHEN DATA_SAIDA IS NOT NULL THEN 'CONCLUIDO'
              WHEN (SYSDATE - DATA_ENTRADA) * 24 > 19 THEN 'ATRASADO'
              ELSE 'EM_SECAGEM'
          END AS STATUS_DINAMICO,

          CASE
              WHEN DATA_SAIDA IS NOT NULL AND DATA_SAIDA < DATA_ENTRADA THEN 'OBS_VERMELHO'
              
              WHEN DATA_SAIDA IS NULL AND ((SYSDATE - DATA_ENTRADA) * 24) <= 19 THEN 'OBS_AZUL'
              
              WHEN DATA_SAIDA IS NULL AND ((SYSDATE - DATA_ENTRADA) * 24) > 19 THEN 'OBS_VERMELHO'
              
              WHEN DATA_SAIDA IS NOT NULL AND ((DATA_SAIDA - DATA_ENTRADA) * 24) BETWEEN 17 AND 19 THEN 'OBS_VERDE'
              
              WHEN DATA_SAIDA IS NOT NULL AND ((DATA_SAIDA - DATA_ENTRADA) * 24) < 17 THEN 'OBS_LARANJA'
              
              ELSE 'OBS_VERMELHO'
          END AS COR_OBSERVACAO,

          CASE
              WHEN DATA_SAIDA IS NOT NULL AND DATA_SAIDA < DATA_ENTRADA THEN 'ERRO - Saída anterior à entrada'
              
              WHEN DATA_SAIDA IS NULL AND ((SYSDATE - DATA_ENTRADA) * 24) <= 19 THEN 'Em processo de secagem'
              
              WHEN DATA_SAIDA IS NULL AND ((SYSDATE - DATA_ENTRADA) * 24) > 19 THEN 'Atrasado - Verificar carrinho'
              
              WHEN DATA_SAIDA IS NOT NULL AND ((DATA_SAIDA - DATA_ENTRADA) * 24) BETWEEN 17 AND 19 THEN 'OK - Tempo dentro do padrão'
              
              WHEN DATA_SAIDA IS NOT NULL AND ((DATA_SAIDA - DATA_ENTRADA) * 24) < 17 THEN 'ALERTA - Saída antes do tempo mínimo'
              
              ELSE 'ALERTA - Tempo acima do padrão'
          END AS OBSERVACAO

      FROM AD_ADCARRINHOS
      ORDER BY DATA_ENTRADA DESC
      FETCH FIRST 100 ROWS ONLY
    </snk:query>

    <div class="painel">
      <h1>Tela: Carrinhos no Secador</h1>

      <h3>
        Responsável pelo controle de entrada e saída dos carrinhos no processo
        de secagem.
      </h3>

      <p>Dados registrados na entrada:</p>

      <ul>
        <li>Número do carrinho (existente ou novo)</li>
        <li>Quantidade de bandejas</li>
        <li>Peso em KG</li>
        <li>Data e hora de entrada (automática)</li>
      </ul>

      <p>Dados registrados na saída:</p>

      <ul>
        <li>Data e hora de saída</li>
        <li>Tempo total de permanência (calculado automaticamente)</li>
      </ul>

      <p>Regras:</p>

      <ul>
        <li>Tempo padrão de secagem: 18 horas</li>
        <li>Tolerância permitida: ± 1 hora</li>
        <li>
          Carrinhos com mais de 19 horas sem saída são marcados como ATRASADO
        </li>
        <li>Carrinhos dentro do período permanecem EM SECAGEM</li>
        <li>Carrinhos com saída registrada são marcados como CONCLUÍDO</li>
      </ul>

      <span class="info"> Pesquise no Sankhya: Carrinhos no Secador </span>
    </div>

    <div class="painel">
      <h3>Movimentação atual</h3>

      <table>
        <tr>
          <th>Carrinho</th>
          <th>Entrada</th>
          <th>Saída</th>
          <th>Bandejas</th>
          <th>Peso (KG)</th>
          <th>Tempo (h)</th>
          <th>Status</th>
          <th>Observação</th>
        </tr>

        <c:forEach items="${movimentacoes.rows}" var="m">
          <tr>
            <td><c:out value="${m.CARRINHO}" /></td>

            <td><c:out value="${m.ENTRADA}" /></td>

            <td>
              <c:out value="${not empty m.SAIDA ? m.SAIDA : '-'}" />
            </td>

            <td><c:out value="${m.BANDEJAS}" /></td>

            <td><c:out value="${m.PESO}" /></td>

            <td><c:out value="${m.TEMPO_DECORRIDO}" />h</td>

            <td class="${m.STATUS_DINAMICO}">
              <c:choose>
                <c:when test="${m.STATUS_DINAMICO eq 'EM_SECAGEM'}">
                  EM SECAGEM
                </c:when>
                <c:otherwise>
                  <c:out value="${m.STATUS_DINAMICO}" />
                </c:otherwise>
              </c:choose>
            </td>

            <td class="${m.COR_OBSERVACAO}">
              <c:out value="${m.OBSERVACAO}" />
            </td>
          </tr>
        </c:forEach>
      </table>
    </div>
  </body>
</html>
