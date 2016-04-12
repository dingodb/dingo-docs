---
title: Known Issues
---

* End users do not have a way to view their PostgreSQL nor cluster health logs; currently only operators can view all logs from across all PostgreSQL service instances

* Do not downsize the cluster - containers are allocated to cluster cells but are not recreated/reassigned if cells are permanently removed
