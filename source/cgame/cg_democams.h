/*
Copyright (C) 2009 German Garcia Fernandez ("Jal")

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
*/

bool CG_DemoCam_IsFree();
bool CG_DemoCam(); // Called each frame
bool CG_DemoCam_Update();
void CG_DrawDemocam2D();
void CG_DemocamInit();
void CG_DemocamShutdown();
void CG_DemocamReset();
int CG_DemoCam_GetViewType();
bool CG_DemoCam_GetThirdPerson();
float CG_DemoCam_GetOrientation( Vec3 * origin, Vec3 * angles, Vec3 * velocity );
void CG_DemoCam_GetViewDef( cg_viewdef_t *view );
