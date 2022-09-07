CREATE TABLE job_function
(
    code VARCHAR(255) not null,
    description VARCHAR(255),
    PRIMARY KEY (code)
);
INSERT INTO job_function
    (code)
SELECT DISTINCT
    [Job function] as [code]
FROM [dbo].[FR051]
WHERE [Job function] != '?' AND [Job function] != 'NULL' AND [Job function] != 'S/O' AND [Job function] IS NOT NULL
order by code
select *
from job_function;

CREATE TABLE type_ressource
(
    code VARCHAR(255) not null,
    description VARCHAR(255),
    PRIMARY KEY (code)
);
INSERT INTO type_ressource
    (code)
SELECT DISTINCT
    [Type Ressources] as [code]
FROM [dbo].[FR051]
WHERE [Type Ressources] != '?' AND [Type Ressources] != 'NULL' AND [Type Ressources] != 'S/O' AND [Type Ressources] IS NOT NULL
ORDER BY code;
select *
from type_ressource;

CREATE TABLE job_qualif
(
    code VARCHAR(255) not null,
    description VARCHAR(255),
    fk_job_function VARCHAR(255) FOREIGN KEY REFERENCES job_function(code),
    PRIMARY KEY (code)
);
INSERT INTO job_qualif
    (code, fk_job_function)
SELECT DISTINCT
    [Job qualif] as [code],
    [job_function].[code] AS [fk_job_function]
FROM [dbo].[FR051], [dbo].[job_function]
WHERE FR051.[Job function] = job_function.code
ORDER BY [code], [fk_job_function];
select *
from job_qualif;

CREATE TABLE own_int_ext_gdc
(
    code VARCHAR(255) not null,
    description VARCHAR(255),
    PRIMARY KEY (code)
);
INSERT INTO own_int_ext_gdc
    (code)
SELECT DISTINCT
    [OWN - Int - Ext - GDC] as [code]
FROM [dbo].[FR051]
WHERE [OWN - Int - Ext - GDC] IS NOT NULL
ORDER BY code;
select *
from own_int_ext_gdc;

CREATE TABLE ssl_portfolio_projet
(
    code VARCHAR(255) not null,
    description VARCHAR(255),
    PRIMARY KEY (code)
);
INSERT INTO ssl_portfolio_projet (code)
select [SSL Report] from dbo.FR051
where [SSL Report] IS NOT NULL
UNION
select [SSL Report] from dbo.Xcheck
where [SSL Report] IS NOT NULL
ORDER BY [SSL Report]
select * from ssl_portfolio_projet;

CREATE TABLE ssl_portfolio_collaborateur
(
    code VARCHAR(255) not null,
    description VARCHAR(255),
    PRIMARY KEY (code)
);
INSERT into ssl_portfolio_collaborateur
    (code)
SELECT DISTINCT
    [SSL collab] as [code]
FROM [dbo].[FR051]
WHERE [SSL collab] IS NOT NULL
UNION
SELECT DISTINCT 
	[SSL Ressources] as code
FROM [dbo].[Xcheck]
WHERE [SSL Ressources] IS NOT NULL
ORDER BY code
select *
from ssl_portfolio_collaborateur

CREATE TABLE ssl_portfolio_bizz
(
    code VARCHAR(255) not null,
    description VARCHAR(255),
    PRIMARY KEY (code)
);
INSERT into ssl_portfolio_bizz
    (code)
SELECT DISTINCT
    [BIZZ] as [code]
FROM [dbo].[FR051]
WHERE BIZZ IS NOT NULL
ORDER BY code;
select *
from ssl_portfolio_bizz;

-- # MARKET UNIT # --
---- # PROJET # ----
CREATE TABLE pu_projet_level1
(
    code VARCHAR(255),
    description VARCHAR(255),
    PRIMARY KEY (code),
);
INSERT INTO pu_projet_level1
    (code)
SELECT DISTINCT
    [PU projet level1]  as code
FROM [dbo].[FR051]
WHERE [PU projet level1] IS NOT NULL
UNION
SELECT DISTINCT
	[PU Projet level1] AS code
FROM [dbo].[Xcheck]
WHERE [PU Projet level1] IS NOT NULL
ORDER BY code
select *
from pu_projet_level1


CREATE TABLE pnl_projet_level1
(
    code VARCHAR(255),
    description VARCHAR(255),
    PRIMARY KEY (code),
);
INSERT INTO pnl_projet_level1
    (code)
SELECT DISTINCT
    [PnL lev1 Mod 3]  as code
FROM [dbo].[FR051]
WHERE [PnL lev1 Mod 3] IS NOT NULL
UNION
SELECT [MU ] as code
FROM [dbo].[Xcheck]
WHERE [MU ] IS NOT NULL
ORDER BY code
select *
from pnl_projet_level1

---- # COLLABORATEUR # ----
CREATE TABLE market_unit_collaborateur
(
    code VARCHAR(255),
    description VARCHAR(255),
    PRIMARY KEY (code),
);
INSERT INTO market_unit_collaborateur
    (code)
SELECT DISTINCT
    [MU employee]  as code
FROM [dbo].[FR051]
WHERE [MU employee] IS NOT NULL
UNION
SELECT DISTINCT
	[MU ] as code
FROM [dbo].[Xcheck]
WHERE [MU ] IS NOT NULL AND [MU ] NOT LIKE '%Offs+G%'
ORDER BY code
select *
from market_unit_collaborateur

-- # MARKET SEGMENT # --
---- # PROJET # ----
--Pnl projet level 2
CREATE TABLE pnl_projet_level2
(
    code VARCHAR(255),
    fk_pnl_projet_level1 VARCHAR(255) FOREIGN KEY REFERENCES pnl_projet_level1(code),
    description VARCHAR(255),
    PRIMARY KEY (code),
);
INSERT INTO pnl_projet_level2
    (code, fk_pnl_projet_level1)
SELECT DISTINCT
    [PnL lev2 Mod 3]  as code,
    [PnL lev1 Mod 3] as fk_pnl_projet_level1
FROM [dbo].[FR051]
WHERE [PnL lev2 Mod 3] IS NOT NULL
UNION
SELECT DISTINCT
	[Market Segment] as code,
	[MU ] as fk_pnl_projet_level1
FROM [dbo].[Xcheck]
WHERE [Market Segment] IS NOT NULL
ORDER BY code, fk_pnl_projet_level1
select *
from pnl_projet_level2

--Pu Projet Level 2
CREATE TABLE pu_projet_level2
(
    code VARCHAR(255) not null,
    code_pu VARCHAR(255),
    fk_pu_projet_level1 VARCHAR(255) FOREIGN KEY REFERENCES pu_projet_level1(code),
    description VARCHAR(255),
    PRIMARY KEY (code),
);
INSERT INTO pu_projet_level2
    (code, code_pu, fk_pu_projet_level1)
SELECT DISTINCT
    CONCAT([PU projet level2], '-', [PU projet level1]) as code,
    [PU projet level2]  as code_pu,
    [PU projet level1] as fk_pu_projet_level1
FROM [dbo].[FR051]
WHERE [PU projet level2] IS NOT NULL
UNION
SELECT DISTINCT
	CONCAT([PU Projet level2], '-', [PU Projet level1]) as code,
    [PU Projet level2]  as code_pu,
    [PU Projet level1] as fk_pu_projet_level1
FROM [dbo].[Xcheck]
WHERE [PU Projet level2] IS NOT NULL
ORDER BY code, code_pu, fk_pu_projet_level1
select *
from pu_projet_level2


---- # COLLABORATEUR # ----
CREATE TABLE market_segment_collaborateur
(
    code VARCHAR(255) NOT NULL,
	code_ms VARCHAR(255) NOT NULL,
    fk_market_unit_collaborateur VARCHAR(255) FOREIGN KEY REFERENCES market_unit_collaborateur(code),
    description VARCHAR(255),
    PRIMARY KEY (code)
);
INSERT INTO market_segment_collaborateur
    (code, code_ms,fk_market_unit_collaborateur)
SELECT DISTINCT
	CONCAT([MS employee], '-', [MU employee]) as code,
    [MS employee]  as code_ms,
    [MU employee] as fk_market_unit_collaborateur
FROM [dbo].[FR051]
WHERE [MS employee] IS NOT NULL AND [MU employee] NOT LIKE '%Offs+G%'
UNION
SELECT DISTINCT
	CONCAT([PU_Ressource (level2)], '-', [PU_Ressource (level1)]) as code,
	[PU_Ressource (level2)] as code_ms,
	[PU_Ressource (level1)] as fk_market_unit_collaborateur
FROM [dbo].[Xcheck]
WHERE [PU_Ressource (level1)] IS NOT NULL AND [PU_Ressource (level2)] IS NOT NULL AND [PU_Ressource (level1)] NOT like '%Offs+G%'
ORDER BY code, fk_market_unit_collaborateur
select *
from market_segment_collaborateur

CREATE TABLE type_projet_level1
(
    code VARCHAR(255),
    description VARCHAR(255),
    PRIMARY KEY (code)
);
INSERT INTO type_projet_level1
    (code)
SELECT DISTINCT
    [Type Projet level1] as code
FROM [dbo].[FR051]
WHERE [Type Projet level1] IS NOT NULL
ORDER BY code
select *
from type_projet_level1;

CREATE TABLE type_projet_level2
(
    code VARCHAR(255),
    fk_type_projet_level1 VARCHAR(255) FOREIGN KEY REFERENCES type_projet_level1(code),
    description VARCHAR(255),
    PRIMARY KEY (code)
);
INSERT INTO type_projet_level2
    (code, fk_type_projet_level1)
SELECT DISTINCT
    [Type Projet level2] as code,
    [Type Projet level1] as fk_type_projet_level1
FROM [dbo].[FR051]
WHERE [Type Projet level2] IS NOT NULL
ORDER BY code
select *
from type_projet_level2;

CREATE TABLE project_type
(
    code VARCHAR(255),
    fk_type_projet_level2 VARCHAR(255) FOREIGN KEY REFERENCES type_projet_level2(code),
    description VARCHAR(255),
    PRIMARY KEY (code)
);
INSERT INTO project_type
    (code, fk_type_projet_level2)
SELECT DISTINCT
    [Project type] as code,
    [Type Projet level2] as fk_type_projet_level2
FROM [dbo].[FR051]
WHERE [Project type] IS NOT NULL
ORDER BY code
select *
from project_type;

CREATE TABLE employee_type
(
    code VARCHAR(255) not null,
    description VARCHAR(255),
    PRIMARY KEY (code)
);
INSERT INTO employee_type
    (code)
SELECT DISTINCT
    [Employee type] as [code]
FROM [dbo].[FR051]
WHERE [Employee type] IS NOT NULL
ORDER BY [code];
select *
from [employee_type];

CREATE TABLE grade
(
    code VARCHAR(255) not null,
    description VARCHAR(255),
    PRIMARY KEY (code)
);
INSERT INTO grade
    (code)
SELECT DISTINCT
    [Grade] as [code]
FROM [dbo].[FR051]
WHERE [Grade] IS NOT NULL
UNION
SELECT DISTINCT
    [Grades] as [code]
FROM [dbo].[Mapping_Grades]
WHERE [Grades] IS NOT NULL
ORDER BY [code];
select *
from [grade];


CREATE TABLE project_prod_unit
(
    code VARCHAR(255) not null,
    description VARCHAR(255),
    PRIMARY KEY (code)
);
INSERT INTO project_prod_unit
    (code)
SELECT DISTINCT
    [Project prod Unit] as [code]
FROM [dbo].[FR051]
WHERE [Project prod Unit] IS NOT NULL
select *
from [project_prod_unit];

CREATE TABLE employee_prod_unit
(
    code VARCHAR(255) not null,
    description VARCHAR(255),
    PRIMARY KEY (code)
);
INSERT INTO employee_prod_unit
    (code)
SELECT DISTINCT
    [Emp prod unit] as [code]
FROM [dbo].[FR051]
WHERE [Emp prod unit] IS NOT NULL
ORDER BY [code];
select *
from [employee_prod_unit];


CREATE TABLE collaborateur
(
    code VARCHAR(255) not null,
    numero VARCHAR(255) not null,
    nom VARCHAR(255),
    PRIMARY KEY (code)
);
INSERT INTO collaborateur
    (
    code,
    numero,
    nom
    )
SELECT DISTINCT
    CONCAT([Employee number], '-', [Employee name]) as [code],
    [Employee number] as [numero],
    [Employee name] as [nom]
FROM
    [dbo].[FR051]
WHERE [Employee number] IS NOT NULL
ORDER BY 
    [numero],
    [nom]
select *
from [collaborateur];

CREATE TABLE depense
(
    code VARCHAR(255) not null,
    commentaire VARCHAR(255),
    exp_type VARCHAR(255),
    type_depense VARCHAR(255),
    PRIMARY KEY (code),
);
INSERT INTO depense
    (code, commentaire, exp_type, type_depense)
SELECT DISTINCT
    CONCAT([Expenditure comment],  '-', [Exp. Type]) as code,
    [Expenditure comment] as commentaire,
    [Exp. type] as [exp_type],
    [Type dépenses] AS [type_depense]
FROM [dbo].[FR051]
WHERE [Expenditure comment] IS NOT NULL
ORDER BY code, commentaire, exp_type, type_depense;
select *
from depense

CREATE TABLE covid_inno
(
    code VARCHAR(255) not null,
    description VARCHAR(255),
    PRIMARY KEY (code)
);
INSERT INTO covid_inno
    (code)
SELECT DISTINCT
    [COVID - INNO] as [code]
FROM [dbo].[FR051]
WHERE [COVID - INNO] IS NOT NULL
ORDER BY [code];
select *
from [covid_inno];

CREATE TABLE sites
(
    code VARCHAR(255) not null,
    description VARCHAR(255),
    PRIMARY KEY (code)
);
INSERT INTO sites
    (code)
SELECT DISTINCT
    [Site] as [code]
FROM [dbo].[FR051]
WHERE [Site] IS NOT NULL
ORDER BY [code];
select *
from [sites];

CREATE TABLE icb_bl
(
    code VARCHAR(255) not null,
    description VARCHAR(255),
    PRIMARY KEY (code)
);
INSERT INTO icb_bl
    (code)
SELECT DISTINCT
    [ICB -BL] as [code]
FROM [dbo].[FR051]
WHERE [ICB -BL] IS NOT NULL
ORDER BY [code];
select *
from [icb_bl];

CREATE TABLE pnl_dbc
(
    code VARCHAR(255) not null,
    description VARCHAR(255),
    PRIMARY KEY (code)
);
INSERT INTO pnl_dbc(code)
SELECT DISTINCT
	[DBC]
FROM THOR
WHERE DBC IS NOT NULL
UNION
SELECT DISTINCT
	[PNL_DBC]
FROM FR051
WHERE PNL_DBC IS NOT NULL
UNION
SELECT DISTINCT
	[DBC]
FROM Xcheck
WHERE DBC IS NOT NULL
ORDER BY [DBC];
select *
from [pnl_dbc];

CREATE TABLE compte_nomme
(
    code VARCHAR(255),
    PRIMARY KEY (code)
);
INSERT INTO compte_nomme
    (code)
SELECT DISTINCT
    CASE [Compte nommé] 
		WHEN 's/o' THEN '0'
		WHEN 'NA' THEN '0'
		ELSE [Compte nommé]
	END AS [code]
FROM [dbo].[FR051]
WHERE [Compte nommé] IS NOT NULL
ORDER BY code;
select *
from [compte_nomme];

--Client final
CREATE TABLE client_final
(
    numero VARCHAR(255) not null,
    nom VARCHAR(255),
    PRIMARY KEY (numero),
    grand_compte VARCHAR(255),
    group_account VARCHAR(255),
    sector_hfm VARCHAR(255),
    industry_hfm VARCHAR(255)
);
INSERT INTO client_final
    (numero, nom, grand_compte, group_account, sector_hfm, industry_hfm)
SELECT numero,
	MAX(nom),
	MAX(grand_compte),
	MAX(group_account),
	MAX(sector_hfm),
	MAX(industry_hfm)
FROM (
SELECT DISTINCT [N°] as numero
      , [Customer name  (as in GFS)] as nom
      , [Regroupement spécifique BU France / APPS] as grand_compte
      , [Group account] as group_account
      , [Sector HFM] as sector_hfm
      , [Industry HFM] as industry_hfm
FROM [dbo].[Referentiel_Client]
WHERE [N°] IS NOT NULL
UNION
SELECT DISTINCT
	[client final Num] as numero
	, MAX([client final name]) as nom
	, MAX([Grands Compte]) as grand_compte
	, MAX([Group Account]) as group_account
	, MAX([Sector HFM]) as sector_hfm
	, MAX([Industry HFM]) as industry_hfm
FROM FR051
WHERE [client final Num] IS NOT NULL
GROUP BY [client final Num]
UNION
SELECT DISTINCT
	[Client Code] as numero
	, MAX([Legal Entity GFS name]) as nom
	, MAX([Ultimate Parent Account]) as grand_compte
	, MAX([Group Account]) as group_account
	, MAX([Sector]) as sector_hfm
	, MAX([UPA Industry]) as industry_hfm
FROM THOR
WHERE [Client Code] IS NOT NULL
GROUP BY [Client Code]
) diaf
GROUP BY numero
ORDER BY numero
select * from client_final
	
CREATE TABLE client_direct
(
    code VARCHAR(255) not null,
    numero VARCHAR(255) not null,
    nom VARCHAR(255),
    type_client VARCHAR(10) /* -- 1 == External | 0 = Internal */,
    PRIMARY KEY (code)
);
INSERT INTO client_direct
    (code, numero, nom, type_client)
SELECT DISTINCT
    CONCAT([Customer number], '-', [Customer name]) as code,
    [Customer number] as [numero],
    [Customer name] as [nom],
    [Cust. type desc] as [type_client]
FROM [dbo].[FR051]
WHERE [Customer number] IS NOT NULL
ORDER BY numero, nom
select *
from client_direct;

CREATE TABLE projet
(
    code VARCHAR(255) not null,
    code_projet VARCHAR(255) not null,
    nom VARCHAR(255),
    PRIMARY KEY (code)
);
INSERT INTO projet
    (
    code,
    code_projet,
    nom
    )
SELECT DISTINCT
    CONCAT([Project number], '-', [Project name]) as [code],
    [Project number] as [code_projet],
    [Project name] as [nom]
FROM
    [dbo].[FR051]
WHERE [Project number] is not NULL
ORDER BY code
select *
from projet

CREATE TABLE gl_periode
(
	datekey VARCHAR(255) NOT NULL,
	date DATE,
	annee INT,
	mois INT,
	PRIMARY KEY (datekey)
)
INSERT INTO gl_periode
SELECT 
	CONCAT(annee,'-',mois) as datekey,
	date,
	annee,
	mois
FROM(
SELECT DISTINCT 
	CONVERT(DATETIME, CONCAT([Mois], '-01'), 20) as [date],
	SUBSTRING([Mois],0,5) as annee,
	CASE
		WHEN [Mois] NOT LIKE '%-0%' AND LEN(SUBSTRING([Mois], 6, 2)) = 1 
			THEN CONCAT('0', SUBSTRING([Mois], 6, 2))
		ELSE SUBSTRING([Mois], 6, 2) 
	END AS mois
FROM THOR) gl_period_tmp
WHERE Mois IS NOT NULL
ORDER BY date
Select * FROM gl_periode

CREATE TABLE version_forcast
(
    code VARCHAR(255) not null,
    description VARCHAR(255),
    PRIMARY KEY (code)
);
INSERT INTO version_forcast(code)
SELECT DISTINCT version_FCST FROM Xcheck
 WHERE version_FCST IS NOT NULL
UNION
SELECT DISTINCT version_FCST FROM THOR
 WHERE version_FCST IS NOT NULL

CREATE TABLE pnl_line_source
(
    code VARCHAR(255) not null,
    description VARCHAR(255),
    PRIMARY KEY (code)
);
INSERT INTO pnl_line_source(code) 
SELECT DISTINCT 
    [PnL Line source] AS code 
FROM Xcheck 
WHERE [PnL Line source] IS NOT NULL


CREATE TABLE pnl_line_destination
(
    code VARCHAR(255) not null,
    description VARCHAR(255),
    PRIMARY KEY (code)
);
INSERT INTO pnl_line_destination(code) 
SELECT DISTINCT 
    [PnL Line Destination] AS code 
FROM Xcheck 
WHERE [PnL Line Destination] IS NOT NULL


CREATE TABLE pnl_block
(
    code VARCHAR(255) not null,
    description VARCHAR(255),
    PRIMARY KEY (code)
);
INSERT INTO pnl_block(code) 
SELECT DISTINCT 
    [PNL Block] AS code 
FROM Xcheck 
WHERE [PNL Block] IS NOT NULL


--selling_mu
CREATE TABLE selling_mu
(
    code VARCHAR(255) not null,
    description VARCHAR(255),
    PRIMARY KEY (code)
)
INSERT INTO [selling_mu] (code)
SELECT DISTINCT [Selling MU] from dbo.THOR
WHERE [Selling MU] IS NOT NULL
SELECT * FROM selling_mu

--selling ms
CREATE TABLE selling_ms
(
    code VARCHAR(255) not null,
    description VARCHAR(255),
    fk_selling_mu VARCHAR(255) FOREIGN KEY REFERENCES selling_mu(code),
    PRIMARY KEY (code)
)
INSERT INTO selling_ms(code,fk_selling_mu)
SELECT DISTINCT [Selling MS], [Selling MU] FROM dbo.THOR
WHERE [Selling MS] IS NOT NULL
SELECT * FROM selling_ms

--stage
CREATE TABLE stage
(
    code VARCHAR(255) not null,
    description VARCHAR(255),
    PRIMARY KEY (code)
);
INSERT INTO stage (code)
SELECT DISTINCT Stage FROM dbo.THOR
WHERE stage IS NOT NULL
SELECT * FROM stage

--interco_flag
CREATE TABLE interco_flag
(
	code VARCHAR(255) NOT NULL,
	description VARCHAR(255)
	PRIMARY KEY (code)
)
INSERT INTO interco_flag (code)
SELECT DISTINCT [Interco Flag] FROM dbo.THOR
WHERE [Interco Flag] IS NOT NULL
SELECT * FROM interco_flag

--Selling Reporting Unit
CREATE TABLE selling_reporting_unit
(
	code VARCHAR(255) NOT NULL,
	description VARCHAR(255),
	PRIMARY KEY (code)
)
INSERT INTO selling_reporting_unit(code)
SELECT DISTINCT [Selling Reporting Unit] FROM THOR
WHERE [Selling Reporting Unit] IS NOT NULL
SELECT *
FROM selling_reporting_unit

--FR051
CREATE TABLE mission
(
    id INT not null IDENTITY(1,1),
    costed_days VARCHAR(255),
    billable_days VARCHAR(255),
    unbilled_days VARCHAR(255),
    cost_of_remuneration VARCHAR(255),
    daily_cost VARCHAR(255),
    revenu_own VARCHAR(255),
    tp_amount_provider VARCHAR(255),
    cor VARCHAR(255),
    charged_expenses VARCHAR(255),
    billed_expenses VARCHAR(255),
    unbilled_expenses VARCHAR(255),
    total_direct_costs VARCHAR(255),
    contributions VARCHAR(255),
    ratio_contribution VARCHAR(255),
    PRIMARY KEY (id),
    fk_gl_periode VARCHAR(255) FOREIGN KEY REFERENCES gl_periode(datekey),
    fk_type_ressource VARCHAR(255) FOREIGN KEY REFERENCES type_ressource(code),
    fk_job_qualif VARCHAR(255) FOREIGN KEY REFERENCES job_qualif(code),
    fk_own_int_ext_gdc VARCHAR(255) FOREIGN KEY REFERENCES own_int_ext_gdc(code),
    fk_ssl_portfolio_projet VARCHAR(255) FOREIGN KEY REFERENCES ssl_portfolio_projet(code),
    fk_ssl_portfolio_collaborateur VARCHAR(255) FOREIGN KEY REFERENCES ssl_portfolio_collaborateur(code),
    fk_pnl_projet_level2 VARCHAR(255) FOREIGN KEY REFERENCES pnl_projet_level2(code),
    fk_pu_projet_level2 VARCHAR(255) FOREIGN KEY REFERENCES pu_projet_level2(code),
    fk_market_segment_collaborateur VARCHAR(255) FOREIGN KEY REFERENCES market_segment_collaborateur(code),
    fk_type_projet_level2 VARCHAR(255) FOREIGN KEY REFERENCES type_projet_level2(code),
    fk_project_type VARCHAR(255) FOREIGN KEY REFERENCES project_type(code),
    fk_employee_type VARCHAR(255) FOREIGN KEY REFERENCES employee_type(code),
    fk_grade VARCHAR(255) FOREIGN KEY REFERENCES grade(code),
    fk_project_prod_unit VARCHAR(255) FOREIGN KEY REFERENCES project_prod_unit(code),
    fk_employee_prod_unit VARCHAR(255) FOREIGN KEY REFERENCES employee_prod_unit(code),
    fk_collaborateur VARCHAR(255) FOREIGN KEY REFERENCES collaborateur(code),
    fk_type_depense VARCHAR(255) FOREIGN KEY REFERENCES depense(code),
    fk_covid_inno VARCHAR(255) FOREIGN KEY REFERENCES covid_inno(code),
    fk_sites VARCHAR(255) FOREIGN KEY REFERENCES sites(code),
    fk_icb_bl VARCHAR(255) FOREIGN KEY REFERENCES icb_bl(code),
    fk_pnl_dbc VARCHAR(255) FOREIGN KEY REFERENCES pnl_dbc(code),
    fk_compte_nomme VARCHAR(255) FOREIGN KEY REFERENCES compte_nomme(code),
    fk_client_final VARCHAR(255) FOREIGN KEY REFERENCES client_final(numero),
    fk_client_direct VARCHAR(255) FOREIGN KEY REFERENCES client_direct(code),
    fk_projet VARCHAR(255) FOREIGN KEY REFERENCES projet(code)
);
INSERT INTO mission
    (
    costed_days,
    billable_days,
    unbilled_days,
    cost_of_remuneration,
    daily_cost,
    revenu_own,
    tp_amount_provider,
    cor,
    charged_expenses,
    billed_expenses,
    unbilled_expenses,
    total_direct_costs,
    contributions,
    ratio_contribution,
    fk_gl_periode,
    fk_type_ressource,
    fk_job_qualif,
    fk_own_int_ext_gdc,
    fk_ssl_portfolio_projet,
    fk_ssl_portfolio_collaborateur,
    fk_pnl_projet_level2,
    fk_pu_projet_level2,
    fk_market_segment_collaborateur,
    fk_type_projet_level2,
    fk_project_type,
    fk_employee_type,
    fk_grade,
    fk_project_prod_unit,
    fk_employee_prod_unit,
    fk_collaborateur,
    fk_type_depense,
    fk_covid_inno,
    fk_sites,
    fk_icb_bl,
    fk_pnl_dbc,
    fk_compte_nomme,
    fk_client_final,
    fk_client_direct,
    fk_projet
    )
SELECT
    [Costed days] as costed_days,
    [Billable days] as billable_days,
    [Unbilled days] as unbilled_days,
    [Cost of remuneration] as cost_of_remuneration,
    [Daily cost] as daily_cost,
    [Revenu own] as revenu_own,
    [TP Amount (provider)] as tp_amount_provider,
    [C.O.R] as cor,
    [Charged expenses] as charged_expenses,
    [Billed expenses] as billed_expenses,
    [Unbilled expenses] as unbilled_expenses,
    [Total direct costs] as total_direct_costs,
    [Contributions] as contributions,
    CASE WHEN [%Contribution] = '#DIV/0' THEN '0' ELSE [%Contribution] END AS ratio_contribution,
    [Gl periode] as fk_gl_periode,
    CASE WHEN [Type Ressources] = '?' OR [Type Ressources] = 'S/O' OR [Type Ressources] = 'null' THEN NULL ELSE [Type Ressources] END AS fk_type_ressource,
    CASE WHEN [Job qualif] = '?' OR [Job qualif] = 'null' THEN NULL ELSE [Job qualif] END AS fk_job_qualif,
    [OWN - Int - Ext - GDC] AS fk_own_int_ext_gdc,
    [SSL Report] AS fk_ssl_portfolio_projet,
    [SSL collab] AS fk_ssl_portfolio_collaborateur,
    [PnL lev2 Mod 3] AS fk_pnl_projet_level2,
    CASE WHEN [PU Projet level2] IS NULL THEN NULL ELSE CONCAT([PU projet level2], '-', [PU projet level1]) END AS fk_pu_projet_level2,
    --[MS employee] AS fk_market_segment_collaborateur,
    CASE WHEN [MS employee] IS NULL THEN NULL ELSE CONCAT([MS employee], '-', REPLACE([MU employee], 'Offs+G27042:N27043hore', 'Offshore')) END AS fk_market_segment_collaborateur,
    [Type Projet level2] AS fk_type_projet_level2,
    [Project type] AS fk_project_type,
    [Employee type] AS fk_employee_type,
    [Grade] AS fk_grade,
    [Project prod unit] AS fk_project_prod_unit,
    [Emp prod unit] AS fk_employee_prod_unit,
    CASE WHEN [Employee number] IS NULL THEN NULL ELSE CONCAT([Employee number], '-', [Employee name]) END AS fk_collaborateur,
    CASE WHEN [Expenditure comment] IS NULL THEN NULL ELSE CONCAT([Expenditure comment],  '-', [Exp. Type]) END AS fk_depense,
    [COVID - INNO ] AS fk_covid_inno,
    [Site] AS fk_sites,
    [ICB -BL] AS fk_icb_bl,
    [PNL_DBC] AS fk_pnl_dbc,
    CASE [Compte nommé] WHEN 's/o' THEN '0' WHEN 'NA' THEN '0' ELSE [Compte nommé] END AS fk_compte_nomme,
    [client final Num] AS fk_client_final,
    CASE WHEN [Customer number] IS NULL THEN NULL ELSE CONCAT([Customer number], '-', [Customer name]) END AS fk_client_direct,
    CASE WHEN [Project number] IS NULL THEN NULL ELSE CONCAT([Project number], '-', [Project name]) END AS fk_projet
FROM
    [dbo].[FR051]
ORDER BY [Project number]
SELECT * FROM mission

CREATE TABLE fact_thor
(
    id INT NOT NULL IDENTITY(1,1),
    original_booking FLOAT,
    converted_booking FLOAT,
    converted_weighted_booking FLOAT,
    converted_total_external_booking FLOAT,
    converted_contribution FLOAT,
    converted_total_internal_booking FLOAT,
    PRIMARY KEY(id),
    fk_gl_periode VARCHAR(255) FOREIGN KEY REFERENCES gl_periode(datekey),
    fk_selling_mu VARCHAR(255) FOREIGN KEY REFERENCES selling_mu(code),
    fk_selling_ms VARCHAR(255) FOREIGN KEY REFERENCES selling_ms(code),
    fk_selling_reporting_unit VARCHAR(255) FOREIGN KEY REFERENCES selling_reporting_unit(code),
    fk_stage VARCHAR(255) FOREIGN KEY REFERENCES stage(code),
    fk_interco_flag VARCHAR(255) FOREIGN KEY REFERENCES interco_flag(code),
    fk_dbc VARCHAR(255) FOREIGN KEY REFERENCES pnl_dbc(code),
    fk_market_segment VARCHAR(255) FOREIGN KEY REFERENCES pnl_projet_level2(code),
    fk_market_unit VARCHAR(255) FOREIGN KEY REFERENCES pnl_projet_level1(code),
    --fk_client_final VARCHAR(255) FOREIGN KEY REFERENCES client_final(numero),
    fk_version_forcast VARCHAR(255) FOREIGN KEY REFERENCES version_forcast(code),
    fk_projet VARCHAR(255)
    --FOREIGN KEY REFERENCES projet(code),
)
INSERT INTO fact_thor
(
    original_booking,
    converted_booking,
    converted_weighted_booking,
    converted_total_external_booking,
    converted_contribution,
    converted_total_internal_booking,
    fk_gl_periode,
    fk_selling_mu,
    fk_selling_ms,
    fk_selling_reporting_unit,
    fk_stage,
    fk_interco_flag,
    fk_dbc,
    fk_market_segment,
    fk_market_unit,
    --fk_client_final,
    fk_version_forcast,
    fk_projet
)
SELECT
    [Original Booking] AS original_booking,
    [Converted Booking] AS converted_booking,
    [Converted Weighted Booking] AS converted_weighted_booking,
    [Converted Total External Booking] AS converted_total_external_booking,
    [Converted Contribution] AS converted_contribution,
    [Converted Total Internal Booking] AS converted_total_internal_booking,
    [Mois] AS fk_gl_periode,
    [Selling MU] AS fk_selling_mu,
    [Selling MS] AS fk_selling_ms,
    [Selling Reporting Unit] as fk_selling_reporting_unit,
    [Stage] AS fk_stage,
    [Interco Flag] AS fk_interco_flag,
    [DBC] AS fk_dbc,
    [MS] AS fk_market_segment,
    [MU] AS fk_market_unit,
    --[Client Code] AS fk_client_final,
    [version_FCST] AS fk_version_forcast,
    [Project Code] AS fk_projet
FROM THOR
SELECT * from fact_thor

CREATE TABLE fact_xcheck
(
    id INT not null IDENTITY(1,1),
    functional_balance FLOAT,
    PRIMARY KEY (id),
    fk_gl_periode VARCHAR(255) FOREIGN KEY REFERENCES gl_periode(datekey),
    fk_dbc VARCHAR(255) FOREIGN KEY REFERENCES pnl_dbc(code),
    fk_pnl_line_source VARCHAR(255) FOREIGN KEY REFERENCES pnl_line_source(code),
    fk_pnl_line_destination VARCHAR(255) FOREIGN KEY REFERENCES pnl_line_destination(code),
    fk_pnl_block VARCHAR(255) FOREIGN KEY REFERENCES pnl_block(code),
    fk_ssl_projet VARCHAR(255) FOREIGN KEY REFERENCES ssl_portfolio_projet(code),
    fk_ssl_ressource VARCHAR(255) FOREIGN KEY REFERENCES ssl_portfolio_collaborateur(code),
    fk_pu_projet_level2 VARCHAR(255) FOREIGN KEY REFERENCES pu_projet_level2(code),
    fk_pu_ressource_level2 VARCHAR(255) FOREIGN KEY REFERENCES market_segment_collaborateur(code),
    fk_market_segment VARCHAR(255) FOREIGN KEY REFERENCES pnl_projet_level2(code),
    --fk_client_final VARCHAR(255) FOREIGN KEY REFERENCES client_final(numero),
    fk_projet VARCHAR(255),
    --FOREIGN KEY REFERENCES projet(code_projet),
    -- seg5
    fk_version_forcast VARCHAR(255) FOREIGN KEY REFERENCES version_forcast(code)
);
INSERT INTO fact_xcheck
(
    functional_balance,
    fk_gl_periode,
    fk_dbc,
    fk_pnl_line_source,
    fk_pnl_line_destination,
    fk_pnl_block,
    fk_ssl_projet,
    fk_ssl_ressource,
    fk_pu_projet_level2,
    fk_pu_ressource_level2,
    fk_market_segment,
    --fk_client_final,
    fk_projet,
    fk_version_forcast
)
SELECT
      [Functional Balance] as functional_balance
    , [Effective Date (yyyy-mm)] as fk_gl_periode
    , [DBC] AS fk_dbc
    , [PnL Line source] AS fk_pnl_line_source
    , [PnL Line Destination] AS fk_pnl_line_destination
    , [PNL Block] AS fk_pnl_block
    , [SSL Report] AS fk_ssl_projet
    , [SSL Ressources] as fk_ssl_ressource
    , CASE WHEN [PU Projet level2] IS NULL THEN NULL ELSE CONCAT([PU projet level2], '-', [PU projet level1]) END AS fk_pu_projet_level2
    , CASE WHEN [PU_Ressource (level2)] IS NULL THEN NULL ELSE CONCAT([PU_Ressource (level2)], '-', REPLACE([PU_Ressource (level1)],'Offs+G27042:N27043hore','Offshore')) END AS fk_pu_ressource_level2
    , [Market Segment] AS fk_market_segment
    --, [Client Final] AS fk_client_final
    , Seg5 As fk_projet
    , version_FCST as fk_version_forcast
FROM [dbo].[Xcheck]
ORDER BY fk_pu_ressource_level2
SELECT * FROM fact_xcheck