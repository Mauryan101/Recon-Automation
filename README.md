# Recon-Automation [PROJECT IN PROGRESS]
Script to automate Web-Application Reconnaissance process. Nothing too fancy. Just made my life easier so I thought I'd share.

FUTURE OF THIS PROJECT:
1: The project is structured in modules where each module would have a specific vulnerability that the user is looking for.
2: The vulnerabilities would include Top-10 from OWASP.

PROGRESS TO DATE:
  August 7th, 2024:
    1: Completed a module of the script to conduct reconnaissance for **Subdomain Takeovers**.
    
USAGE AND PARAMETERS:
1: Modify the shell script to be able to execute the script: 
  _chmod +x main.sh_
  
2: _./main.sh domainName .. Nth domainName_

PHASES OF THE SCRIPT

1: SCOPE DISCOVERY

2: URL FILTERING AND PROBING

3: VULNERABILITY ANALYSIS


SUBDOMAIN TAKEOVER VULNERABILITY
  1: The script looks for HTTP status codes **404 - Not Found, 403 - Forbidden, 400 - Bad Request, 200 - OK with Default Pages**
  
    1.1: **404 Not Found** - This indicates that the subdomain is in existence but not the resource. If the CNAME record of the subdomain is pointing towards an **NXDOMAIN** or an **unclaimed service**, the subdomain can be taken over.
    
    1.2: 403 Forbidden - This indicates that the requested resource has access restrictions applied to it. However, this could also be an indication that the service running on the subdomain is not properly configured.
    
    1.3: 400 Bad Request - This indicates a misconfigured service meaning it could have been decommissioned. If the CNAME points to an NXDOMAIN, the subdomain can be taken over.
    
    1.4: 200 OK - If the response is a generic default page or a default page from the cloud provider, this could be susceptible to a subdomain takeover. 
    
  2: The script does DNS enumeration using _dnsrecon_ and filters out HTTP status codes that are mentioned above.

  3: The user can then analyze the CNAME records to see if they're pointing towards an NXDOMAIN or an unclaimed server for a successful subdomain takeover.

