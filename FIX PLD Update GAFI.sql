



UPDATE p SET p.ExclusionGAFI=1
FROM dbo.tCTLpaises p  WITH(NOLOCK) WHERE p.Codigo IN ('PRK','IRN','MMR','ALB','BRB','SYR','NIC','YEM','MAR','BWA','BFA','KHM','CYM','GHA','JAM','MUS','PAN','SEN','UGA','ZWE')


