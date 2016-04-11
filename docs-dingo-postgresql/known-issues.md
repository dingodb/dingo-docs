---
title: Known Issues
---

* End users do not have a way to view their PostgreSQL nor cluster health logs; currently only operators can view all logs from across all PostgreSQL service instances

* Do not downsize the cluster - the knowledge that a container in a cluster exists is stored on the cell/persistent disk that it is running upon
