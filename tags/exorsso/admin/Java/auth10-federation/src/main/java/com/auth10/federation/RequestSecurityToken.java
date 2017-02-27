/*--------------------------------------------------------------------------------------+
 |
 |     $Source: $
 |    $RCSfile: $
 |   $Revision:   1.0  $
 |       $Date:   Feb 27 2017 06:48:00  $
 |     $Author:   Upendra.Hukeri  $
 |
 |  $Copyright: (c) 2009 Bentley Systems, Incorporated. All rights reserved. $
 |
 | Licensed under the Apache License, Version 2.0 (the "License");
 | you may not use this file except in compliance with the License.
 | You may obtain a copy of the License at
 | http://www.apache.org/licenses/LICENSE-2.0
 |
 | See the Apache Version 2.0 License for specific language governing
 | permissions and limitations under the License.
 +--------------------------------------------------------------------------------------*/

package com.auth10.federation;

import java.util.List;
import java.util.Map;

public class RequestSecurityToken
{
    public String TokenType;

    public String KeyType;

    public String AppliesTo;

    public String AppliesToBootstrapToken;

    public List<ClaimType> Claims;

    public int Lifetime;

    public String ActAs;

    public String OnBehalfOf;

    public Map<String, Object> Properties;

    public String DeviceId;

    public String AppId;

    public String LoginContext;
}
