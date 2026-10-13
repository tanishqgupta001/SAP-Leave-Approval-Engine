# Enterprise Employee Leave Management & Approval Engine

An end-to-end custom business workflow and leave processing engine developed in SAP ABAP. The solution integrates core Data Dictionary (DDIC) modeling, high-performance in-memory processing via Field-Symbols, transactional database persistence (SAP LUW), and modern Object-Oriented ALV (`CL_SALV_TABLE`) grid reporting.

---

## 📌 Architecture & Business Workflow

```text
[ Data Dictionary: SE11 ]
   │
   ├── Domain (ZTG_LV_STATUS) ───────> Technical type (CHAR 1) + Fixed values (P, A, R)
   ├── Data Element (ZTG_DE_LV_STATUS) > Semantic UI field labels ('Leave Status')
   └── Database Table (ZLEAVE_REQ) ───> Storage engine with primary keys & client isolation
             │
             │ (Data Ingestion via ZPRG_GENERATE_LEAVES)
             ▼
   [ Database Records: Status = 'P' (Pending) ]
             │
             │ Modern Open SQL (SELECT ... WHERE status = @p_status)
             ▼
   [ Application Server RAM: Internal Table (lt_leaves) ]
             │
             │ Pointer Loop (LOOP AT ... ASSIGNING FIELD-SYMBOL)
             ▼
   [ Business Rule Engine: IF days <= 5 -> 'A' ELSE -> 'R' ]
             │
             ├── Database Persistence: UPDATE zleave_req + COMMIT WORK
             └── UI Presentation Layer: CL_SALV_TABLE Factory Grid Display


 
 🚀 Key Highlights & Technical Features
DDIC Data Modeling: Custom transparent database table (ZLEAVE_REQ), data element (ZTG_DE_LV_STATUS), and domain (ZTG_LV_STATUS) configured with fixed value domain definitions and technical storage settings.

In-Memory Optimization: Direct in-place internal table manipulation using ABAP Field-Symbols (ASSIGNING FIELD-SYMBOL(<lfs_leave>)), eliminating expensive memory copy overhead caused by legacy work areas.

Transactional Consistency: Managed SAP Logical Unit of Work (LUW) using array operations (UPDATE ... FROM TABLE) paired with explicit COMMIT WORK and rollback error handling.

Modern OO-ALV Reporting: Programmatic grid output using CL_SALV_TABLE with auto-column optimization and interactive display functions.

Runtime Persistence & Inspection: Verified end-to-end state transitions from batch ingestion to permanent database updates via Transaction SE16N.

🛠️ Tech Stack & Tools
Backend: SAP NetWeaver ABAP 7.5+

Database Tools: Transaction SE11 (DDIC), Transaction SE16N

Development & UI: Transaction SE38 (ABAP Editor), CL_SALV_TABLE

Data Integrity: SAP LUW (COMMIT WORK / ROLLBACK WORK)

📸 Execution & System Proofs
1. Test Data Batch Ingestion
Seeding initial leave requests with status 'P' (Pending):

2. Manager Processing Selection Filter
Selection screen accepting leave processing filters:

3. Live OO-ALV Grid Output
Business engine evaluating threshold rules (<= 5 Approved, > 5 Rejected):

4. Database Persistence Verification (SE16N)
Permanent updates committed to database table ZLEAVE_REQ:

├── README.md
├── src/
│   ├── zprg_generate_leaves.abap        # Test data batch ingestion script
│   └── zprg_leave_approval_engine.abap   # Core approval engine & OO-ALV report
└── (Screenshots / Execution Proofs)
