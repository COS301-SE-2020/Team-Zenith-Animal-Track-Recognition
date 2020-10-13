import { AuthGuardService as AuthGuard } from './services/auth-guard.service';
import { AnimalGroupsComponent } from './views/animals/animals-groups/animal-groups.component';
import { AnimalsComponent } from './views/animals/animals.component';
import { AnimalProfileComponent } from './views/animal-profile/animal-profile.component';
import { AnimalsGalleryComponent } from './views/animals/animals-gallery/animals-gallery.component';
import { AnimalPhotosComponent } from './views/animals/animals-gallery/animal-photos/animal-photos.component';
import { AnimalStatisticsComponent } from './views/overview/animal-statistics/animal-statistics.component';
import { LoginComponent } from './views/login/login.component';
import { RangersComponent } from './views/rangers/rangers.component';
import { RangerProfileComponent } from './views/ranger-profile/ranger-profile.component';
import { RangerPermissionsComponent } from './views/ranger-permissions/ranger-permissions.component';
import { RangerStatisticsComponent } from './views/overview/ranger-statistics/ranger-statistics.component';
import { TrackIdentificationsComponent } from './views/track-identifications/track-identifications.component';
import { NgModule, Component } from '@angular/core';
import { Routes, RouterModule, CanActivate } from '@angular/router';

const routes: Routes = [
  { path: '', redirectTo: 'login', pathMatch: 'full' },
  { path: 'login', component: LoginComponent },
  { path: 'animals', component: AnimalsComponent, canActivate: [AuthGuard] },
  { path: 'animals/information', component: AnimalProfileComponent, canActivate: [AuthGuard] },
  { path: 'animals/gallery', component: AnimalsGalleryComponent, canActivate: [AuthGuard] },
  { path: 'animals/groups', component: AnimalGroupsComponent, canActivate: [AuthGuard] },
  { path: 'animals/gallery/photos', component: AnimalPhotosComponent, canActivate: [AuthGuard] },
  { path: 'rangers', component: RangersComponent, canActivate: [AuthGuard] },  
  { path: 'rangers/profiles', component: RangerProfileComponent, canActivate: [AuthGuard] },
  { path: 'rangers/permissions', component: RangerPermissionsComponent, canActivate: [AuthGuard] },
  { path: 'identifications', component: TrackIdentificationsComponent, canActivate: [AuthGuard] },
  { path: 'animal-statistics', component: AnimalStatisticsComponent, canActivate: [AuthGuard] },
  { path: 'ranger-statistics', component: RangerStatisticsComponent, canActivate: [AuthGuard] },
  { path: '**', redirectTo: '', pathMatch: 'full'}
];

@NgModule({
  declarations: [
  ],
  imports: [RouterModule.forRoot(routes, { onSameUrlNavigation: 'reload' })],
  exports: [RouterModule]
})
export class AppRoutingModule { }
