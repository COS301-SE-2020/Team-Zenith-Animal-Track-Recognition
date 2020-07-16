import { AuthGuardService as AuthGuard } from './services/auth-guard.service';
import { SettingsComponent } from './settings/settings.component';
import { RangersComponent } from './rangers/rangers.component';
import { OverviewComponent } from './overview/overview.component';
import { LoginComponent } from './login/login.component';
import { GeotagsComponent } from './geotags/geotags.component';
import { AnimalsComponent } from './animals/animals.component';
import { NgModule, Component } from '@angular/core';
import { Routes, RouterModule, CanActivate } from '@angular/router';

const routes: Routes = [
  { path: '', redirectTo: 'login', pathMatch: 'full' },
  { path: 'login', component: LoginComponent },
  { path: 'animals', component: AnimalsComponent/*, canActivate: [AuthGuard] */},
  { path: 'settings', component: SettingsComponent/*, canActivate: [AuthGuard] */},
  { path: 'rangers', component: RangersComponent/*, canActivate: [AuthGuard] */},
  { path: 'geotag', component: GeotagsComponent/*, canActivate: [AuthGuard] */},
  { path: 'overview', component: OverviewComponent/*, canActivate: [AuthGuard] */},
  { path: '**', redirectTo: '', pathMatch: 'full'}
];

@NgModule({
  declarations: [
  ],
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
