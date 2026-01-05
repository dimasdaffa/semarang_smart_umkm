# Work Breakdown Structure (WBS)
## SUSMAS - Semarang UMKM Smart Mapping & Analytics System v2.0

**Tanggal Mulai**: 5 Januari 2026  
**Durasi Total**: 12 Minggu  
**Tim**: 5 Orang

---

## 👥 Tim Proyek

| ID | Nama | Role | Skill |
|----|------|------|-------|
| TM-01 | **Dimas Daffa** | Project Manager | Planning, Coordination, Stakeholder Management |
| TM-02 | **Ahmad Fariz** | Lead Developer | Flutter, Architecture, Code Review |
| TM-03 | **Rina Kusuma** | Frontend Developer | UI/UX, Widget Development, Animation |
| TM-04 | **Budi Santoso** | Backend Developer | Services, Data Layer, Algorithm |
| TM-05 | **Siti Aminah** | QA Engineer | Testing, Documentation, Quality |

---

## 📋 WBS Detail

### Level 0: Proyek Utama
```
1.0 SUSMAS v2.0 - Sistem Pemetaan Cerdas UMKM
```

---

### Level 1-4: Breakdown Detail

## 1. PROJECT MANAGEMENT (PM)

| WBS ID | Task | PIC | Start | End | Durasi | Dependencies |
|--------|------|-----|-------|-----|--------|--------------|
| **1.1** | **Initiating** | | | | | |
| 1.1.1 | Project Charter Development | Dimas Daffa | 05/01/2026 | 06/01/2026 | 2 hari | - |
| 1.1.2 | Stakeholder Identification | Dimas Daffa | 05/01/2026 | 06/01/2026 | 2 hari | - |
| 1.1.3 | Kickoff Meeting | Dimas Daffa | 07/01/2026 | 07/01/2026 | 1 hari | 1.1.1, 1.1.2 |
| **1.2** | **Planning** | | | | | |
| 1.2.1 | Requirements Gathering | Dimas Daffa, Siti Aminah | 07/01/2026 | 10/01/2026 | 4 hari | 1.1.3 |
| 1.2.2 | FRS Document Creation | Siti Aminah | 08/01/2026 | 11/01/2026 | 4 hari | 1.2.1 |
| 1.2.3 | Technical Design | Ahmad Fariz | 09/01/2026 | 13/01/2026 | 5 hari | 1.2.1 |
| 1.2.4 | WBS & Gantt Chart | Dimas Daffa | 10/01/2026 | 12/01/2026 | 3 hari | 1.2.3 |
| 1.2.5 | Sprint Planning | Dimas Daffa | 13/01/2026 | 13/01/2026 | 1 hari | 1.2.4 |
| **1.3** | **Monitoring & Control** | | | | | |
| 1.3.1 | Daily Standup | Dimas Daffa | 14/01/2026 | 28/03/2026 | Ongoing | 1.2.5 |
| 1.3.2 | Sprint Review | Dimas Daffa | Bi-weekly | - | Ongoing | - |
| 1.3.3 | Risk Monitoring | Dimas Daffa | Weekly | - | Ongoing | - |
| **1.4** | **Closing** | | | | | |
| 1.4.1 | Final Documentation | Siti Aminah | 23/03/2026 | 26/03/2026 | 4 hari | 6.4 |
| 1.4.2 | Handover & Training | Dimas Daffa | 27/03/2026 | 28/03/2026 | 2 hari | 1.4.1 |

---

## 2. DATA MODEL ENHANCEMENT

| WBS ID | Task | PIC | Start | End | Durasi | Dependencies |
|--------|------|-----|-------|-----|--------|--------------|
| **2.1** | **Entity Design** | | | | | |
| 2.1.1 | Design BahanBaku Model | Budi Santoso | 14/01/2026 | 15/01/2026 | 2 hari | 1.2.3 |
| 2.1.2 | Design AlatProduksi Model | Budi Santoso | 14/01/2026 | 15/01/2026 | 2 hari | 1.2.3 |
| 2.1.3 | Design SentraProduksi Model | Budi Santoso | 16/01/2026 | 17/01/2026 | 2 hari | 2.1.1, 2.1.2 |
| **2.2** | **UMKM Model Update** | | | | | |
| 2.2.1 | Add Production Fields | Budi Santoso | 18/01/2026 | 18/01/2026 | 1 hari | 2.1.3 |
| 2.2.2 | Add Helper Methods | Budi Santoso | 19/01/2026 | 19/01/2026 | 1 hari | 2.2.1 |
| **2.3** | **Mock Data Generation** | | | | | |
| 2.3.1 | Create Material Catalog | Budi Santoso | 20/01/2026 | 21/01/2026 | 2 hari | 2.2.2 |
| 2.3.2 | Create Equipment Catalog | Budi Santoso | 20/01/2026 | 21/01/2026 | 2 hari | 2.2.2 |
| 2.3.3 | Enrich UMKM Mock Data | Budi Santoso | 22/01/2026 | 24/01/2026 | 3 hari | 2.3.1, 2.3.2 |
| 2.3.4 | Code Review Data Models | Ahmad Fariz | 25/01/2026 | 25/01/2026 | 1 hari | 2.3.3 |

---

## 3. INPUT MODULE ENHANCEMENT

| WBS ID | Task | PIC | Start | End | Durasi | Dependencies |
|--------|------|-----|-------|-----|--------|--------------|
| **3.1** | **Material Input Widget** | | | | | |
| 3.1.1 | UI Design Material Picker | Rina Kusuma | 26/01/2026 | 28/01/2026 | 3 hari | 2.3.4 |
| 3.1.2 | Multi-select Component | Rina Kusuma | 29/01/2026 | 31/01/2026 | 3 hari | 3.1.1 |
| 3.1.3 | Validation Logic | Budi Santoso | 01/02/2026 | 02/02/2026 | 2 hari | 3.1.2 |
| **3.2** | **Equipment Input Widget** | | | | | |
| 3.2.1 | UI Design Equipment Picker | Rina Kusuma | 26/01/2026 | 28/01/2026 | 3 hari | 2.3.4 |
| 3.2.2 | Multi-select Component | Rina Kusuma | 29/01/2026 | 31/01/2026 | 3 hari | 3.2.1 |
| 3.2.3 | Validation Logic | Budi Santoso | 01/02/2026 | 02/02/2026 | 2 hari | 3.2.2 |
| **3.3** | **Form Integration** | | | | | |
| 3.3.1 | Update InputDataPage | Rina Kusuma | 03/02/2026 | 05/02/2026 | 3 hari | 3.1.3, 3.2.3 |
| 3.3.2 | Add Confirmation Dialog | Rina Kusuma | 06/02/2026 | 06/02/2026 | 1 hari | 3.3.1 |
| 3.3.3 | Code Review Input Module | Ahmad Fariz | 07/02/2026 | 07/02/2026 | 1 hari | 3.3.2 |

---

## 4. ANALYTICS ENGINE

| WBS ID | Task | PIC | Start | End | Durasi | Dependencies |
|--------|------|-----|-------|-----|--------|--------------|
| **4.1** | **Clustering Algorithm** | | | | | |
| 4.1.1 | Implement Jaccard Similarity | Ahmad Fariz | 08/02/2026 | 11/02/2026 | 4 hari | 3.3.3 |
| 4.1.2 | Material Clustering | Ahmad Fariz | 12/02/2026 | 14/02/2026 | 3 hari | 4.1.1 |
| 4.1.3 | Equipment Clustering | Ahmad Fariz | 12/02/2026 | 14/02/2026 | 3 hari | 4.1.1 |
| 4.1.4 | Proximity Analysis | Budi Santoso | 15/02/2026 | 17/02/2026 | 3 hari | 4.1.2, 4.1.3 |
| **4.2** | **Sentra Identification** | | | | | |
| 4.2.1 | Cluster Formation Logic | Ahmad Fariz | 18/02/2026 | 20/02/2026 | 3 hari | 4.1.4 |
| 4.2.2 | Sentra Metadata Generation | Budi Santoso | 21/02/2026 | 23/02/2026 | 3 hari | 4.2.1 |
| 4.2.3 | Name & Description Generator | Budi Santoso | 24/02/2026 | 25/02/2026 | 2 hari | 4.2.2 |
| **4.3** | **Recommendation Engine** | | | | | |
| 4.3.1 | Policy Suggestions Logic | Ahmad Fariz | 26/02/2026 | 28/02/2026 | 3 hari | 4.2.3 |
| 4.3.2 | Code Review Analytics | Ahmad Fariz | 01/03/2026 | 01/03/2026 | 1 hari | 4.3.1 |

---

## 5. VISUALIZATION MODULE

| WBS ID | Task | PIC | Start | End | Durasi | Dependencies |
|--------|------|-----|-------|-----|--------|--------------|
| **5.1** | **Sentra List Page** | | | | | |
| 5.1.1 | List View UI Design | Rina Kusuma | 02/03/2026 | 04/03/2026 | 3 hari | 4.3.2 |
| 5.1.2 | Filter & Search Component | Rina Kusuma | 05/03/2026 | 06/03/2026 | 2 hari | 5.1.1 |
| 5.1.3 | Sentra Card Component | Rina Kusuma | 07/03/2026 | 08/03/2026 | 2 hari | 5.1.2 |
| **5.2** | **Sentra Detail Page** | | | | | |
| 5.2.1 | Header with Map | Rina Kusuma | 09/03/2026 | 10/03/2026 | 2 hari | 5.1.3 |
| 5.2.2 | Statistics Section | Rina Kusuma | 11/03/2026 | 12/03/2026 | 2 hari | 5.2.1 |
| 5.2.3 | Health Chart (Pie) | Rina Kusuma | 13/03/2026 | 13/03/2026 | 1 hari | 5.2.2 |
| 5.2.4 | Member UMKM List | Rina Kusuma | 14/03/2026 | 14/03/2026 | 1 hari | 5.2.3 |
| **5.3** | **Map Overlay** | | | | | |
| 5.3.1 | Zone Circle Layer | Ahmad Fariz | 15/03/2026 | 16/03/2026 | 2 hari | 5.2.4 |
| 5.3.2 | Legend Update | Rina Kusuma | 17/03/2026 | 17/03/2026 | 1 hari | 5.3.1 |
| **5.4** | **Dashboard Enhancement** | | | | | |
| 5.4.1 | Sentra Summary Widget | Rina Kusuma | 18/03/2026 | 19/03/2026 | 2 hari | 5.3.2 |
| 5.4.2 | Navigation Integration | Ahmad Fariz | 20/03/2026 | 20/03/2026 | 1 hari | 5.4.1 |

---

## 6. INTEGRATION & TESTING

| WBS ID | Task | PIC | Start | End | Durasi | Dependencies |
|--------|------|-----|-------|-----|--------|--------------|
| **6.1** | **Unit Testing** | | | | | |
| 6.1.1 | Test Data Models | Siti Aminah | 21/03/2026 | 21/03/2026 | 1 hari | 5.4.2 |
| 6.1.2 | Test Clustering Algorithm | Siti Aminah | 22/03/2026 | 22/03/2026 | 1 hari | 6.1.1 |
| **6.2** | **Integration Testing** | | | | | |
| 6.2.1 | Test Input to Clustering Flow | Siti Aminah | 23/03/2026 | 23/03/2026 | 1 hari | 6.1.2 |
| 6.2.2 | Test Navigation Flow | Siti Aminah | 24/03/2026 | 24/03/2026 | 1 hari | 6.2.1 |
| **6.3** | **UAT** | | | | | |
| 6.3.1 | UAT Preparation | Siti Aminah | 25/03/2026 | 25/03/2026 | 1 hari | 6.2.2 |
| 6.3.2 | UAT Execution | Siti Aminah, Dimas Daffa | 26/03/2026 | 26/03/2026 | 1 hari | 6.3.1 |
| **6.4** | **Bug Fixing** | | | | | |
| 6.4.1 | Critical Bug Fixes | Ahmad Fariz, Budi Santoso | 27/03/2026 | 27/03/2026 | 1 hari | 6.3.2 |

---

## 7. DEPLOYMENT

| WBS ID | Task | PIC | Start | End | Durasi | Dependencies |
|--------|------|-----|-------|-----|--------|--------------|
| 7.1 | Build Release (Web) | Ahmad Fariz | 28/03/2026 | 28/03/2026 | 1 hari | 6.4.1 |
| 7.2 | Build Release (Android) | Ahmad Fariz | 28/03/2026 | 28/03/2026 | 1 hari | 6.4.1 |
| 7.3 | User Documentation | Siti Aminah | 28/03/2026 | 28/03/2026 | 1 hari | 7.1 |

---

## 📊 Summary Statistics

| Metric | Value |
|--------|-------|
| Total Work Packages | 58 |
| Total Duration | 12 Minggu (84 hari kerja) |
| Project Start | 5 Januari 2026 |
| Project End | 28 Maret 2026 |
| Team Size | 5 orang |

### Effort Distribution by Role

| Role | Work Packages | Percentage |
|------|---------------|------------|
| Dimas Daffa (PM) | 12 | 21% |
| Ahmad Fariz (Lead Dev) | 16 | 28% |
| Rina Kusuma (Frontend) | 18 | 31% |
| Budi Santoso (Backend) | 14 | 24% |
| Siti Aminah (QA) | 12 | 21% |

> *Note: Beberapa work packages dikerjakan secara paralel dan overlap*

---

*Generated: 5 Januari 2026*
