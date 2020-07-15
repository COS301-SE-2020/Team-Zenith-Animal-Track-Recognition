import { SettingsComponent } from './settings/settings.component';
import { RangersComponent } from './rangers/rangers.component';
import { OverviewComponent } from './overview/overview.component';
import { LoginComponent } from './login/login.component';
import { GeotagsComponent } from './geotags/geotags.component';
import { AnimalsComponent } from './animals/animals.component';
import { NgModule, Component } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

const routes: Routes = [
  { path: '', redirectTo: 'login', pathMatch: 'full' },
  { path: 'login', component: LoginComponent },
  { path: 'animals', component: AnimalsComponent },
  { path: 'settings', component: SettingsComponent },
  { path: 'rangers', component: RangersComponent },
  { path: 'geotag', component: GeotagsComponent },
  { path: 'overview', component: OverviewComponent },
];

@NgModule({
  declarations: [
  ],
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
