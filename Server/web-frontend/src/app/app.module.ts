import { AuthGuardService } from './services/auth-guard.service';
import { HttpClient, HttpClientModule } from '@angular/common/http';
import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { Ng2SearchPipeModule } from 'ng2-search-filter';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { LoginComponent } from './views/login/login.component';
import { OverviewComponent } from './views/overview/overview.component';
import { AnimalsToolbarComponent } from './views/animals/animals-toolbar/animals-toolbar.component';
import { AnimalSearchSidenavComponent } from './views/animals/animal-search-sidenav/animal-search-sidenav.component';
import { AnimalProfileComponent } from './views/animal-profile/animal-profile.component'; 
import { AnimalInfoCardComponent } from './views/animals/animal-info-card/animal-info-card.component';
import { EditAnimalInfoComponent } from './views/animals/edit-animal-info/edit-animal-info.component';
import { AddAnimalComponent } from './views/animals/add-animal/add-animal.component';
import { AnimalsComponent } from './views/animals/animals.component';
import { AnimalsGalleryComponent } from './views/animals/animals-gallery/animals-gallery.component';
import { AnimalsGalleryToolbarComponent } from './views/animals/animals-gallery/animals-gallery-toolbar/animals-gallery-toolbar.component';
import { AnimalsGalleryCardComponent } from './views/animals/animals-gallery/animals-gallery-card/animals-gallery-card.component';
import { AnimalPhotosComponent } from './views/animals/animals-gallery/animal-photos/animal-photos.component';
import { AnimalPhotoDetailsComponent } from './views/animals/animals-gallery/animal-photos/animal-photo-details/animal-photo-details.component'; 
import { RangersComponent } from './views/rangers/rangers.component';
import { RangersToolbarComponent } from './views/rangers/rangers-toolbar/rangers-toolbar.component';
import { RangerSearchSidenavCompComponent } from './views/rangers/ranger-search-sidenav-comp/ranger-search-sidenav-comp.component';
import { RangerProfileCardComponent } from './views/rangers/ranger-profile-card/ranger-profile-card.component';
import { AddRangerComponent } from './views/rangers/add-ranger/add-ranger.component';
import { EditRangerInfoComponent } from './views/rangers/edit-ranger-info/edit-ranger-info.component';
import { DeleteRangerComponent } from './views/rangers/delete-ranger/delete-ranger.component';
import { RangerProfileComponent } from './views/ranger-profile/ranger-profile.component';
import { RangerPermissionsComponent } from './views/ranger-permissions/ranger-permissions.component';
import { TrackIdentificationsComponent } from './views/track-identifications/track-identifications.component';
import { TrackIdentificationsToolbarComponent } from './views/track-identifications/track-identifications-toolbar/track-identifications-toolbar.component';
import { TrackIdentificationsMapComponent } from './views/track-identifications/track-identifications-map/track-identifications-map.component';
import { TrackIdentificationsSidenavComponent } from './views/track-identifications/track-identifications-sidenav/track-identifications-sidenav.component';
import { PersonalRangerPermissionComponentComponent } from './views/personal-ranger-permission-component/personal-ranger-permission-component.component';
import { SettingsComponent } from './views/settings/settings.component';
import { SideNavigationComponent } from './components/side-navigation/side-navigation.component';
import { UtilityNavigationComponent } from './components/utility-navigation/utility-navigation.component';


import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatIconModule } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';
import { MatButtonToggleModule } from '@angular/material/button-toggle';
import { MatSelectModule } from '@angular/material/select';
import { MatSidenavModule } from '@angular/material/sidenav';
import { MatListModule } from '@angular/material/list';
import { MatCardModule } from '@angular/material/card';
import { MatMenuModule } from '@angular/material/menu';
import { MatDialogModule } from '@angular/material/dialog';
import { MatDatepickerModule } from '@angular/material/datepicker';
import { MatNativeDateModule } from '@angular/material/core';
import { MatBadgeModule } from '@angular/material/badge';
import { MatExpansionModule } from '@angular/material/expansion';
import { MatTableModule } from '@angular/material/table';
import { MatRadioModule } from '@angular/material/radio';
import { MatTabsModule } from '@angular/material/tabs';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { MatAutocompleteModule } from '@angular/material/autocomplete';
import { MatSnackBarModule } from '@angular/material/snack-bar';
import { MatStepperModule } from '@angular/material/stepper';
import { MatChipsModule } from '@angular/material/chips';
import { MatDividerModule } from '@angular/material/divider';
import { MatGridListModule } from '@angular/material/grid-list';
import { NgbModule } from '@ng-bootstrap/ng-bootstrap';

import { GoogleMapsModule } from '@angular/google-maps';
import { RelativeTimeMPipe } from './pipes/relative-time-m.pipe';

@NgModule({
  declarations: [
    AppComponent,
    AddRangerComponent,
    LoginComponent,
    OverviewComponent,
    AnimalsComponent,
	AnimalsGalleryComponent,
    AnimalsGalleryToolbarComponent,
    AnimalsGalleryCardComponent,
    AnimalPhotosComponent,
    AnimalPhotoDetailsComponent,
    RangersComponent,
    RangersToolbarComponent,
    RangerSearchSidenavCompComponent,
    RangerProfileCardComponent,
    TrackIdentificationsComponent,
    TrackIdentificationsToolbarComponent,
    TrackIdentificationsMapComponent,
    TrackIdentificationsSidenavComponent,
    SettingsComponent,
    SideNavigationComponent,
    UtilityNavigationComponent,
    RangerPermissionsComponent,
    EditRangerInfoComponent,
    DeleteRangerComponent,
    AnimalsToolbarComponent,
    AnimalSearchSidenavComponent,
    AnimalInfoCardComponent,
    EditAnimalInfoComponent,
    AddAnimalComponent,
    RangerProfileComponent,
  	AnimalProfileComponent,
    PersonalRangerPermissionComponentComponent,
    AnimalProfileComponent,
    RelativeTimeMPipe
	],
  imports: [
    BrowserModule,
    BrowserAnimationsModule,
    FormsModule,
    ReactiveFormsModule,
    HttpClientModule,
    AppRoutingModule,
    Ng2SearchPipeModule,
    MatFormFieldModule,
    MatInputModule,
    MatIconModule,
    MatButtonModule,
    MatButtonToggleModule,
    MatSelectModule,
    MatSidenavModule,
    MatListModule,
    MatCardModule,
    MatMenuModule,
    MatDialogModule,
    MatDatepickerModule,
    MatNativeDateModule,
    MatBadgeModule,
    MatExpansionModule,
    MatTableModule,
    MatRadioModule,
    MatTabsModule,
    MatProgressSpinnerModule,
    MatAutocompleteModule,
    MatSnackBarModule,
    MatStepperModule,
    MatChipsModule,
    MatProgressBarModule,
    MatDividerModule,
  	MatGridListModule,
    NgbModule,
    MatGridListModule,
    GoogleMapsModule
  ],
  providers: [AuthGuardService],
  entryComponents: [
    AddRangerComponent,
    EditRangerInfoComponent,
    DeleteRangerComponent,
    EditAnimalInfoComponent,
    AddAnimalComponent,
	AnimalPhotoDetailsComponent
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
