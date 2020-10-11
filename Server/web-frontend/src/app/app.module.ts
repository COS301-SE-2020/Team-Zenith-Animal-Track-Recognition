import { AnimalGroupsComponent } from './views/animals/animals-groups/animal-groups.component';
import { AuthGuardService } from './services/auth-guard.service';
import { HttpClient, HttpClientModule } from '@angular/common/http';
import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { Ng2SearchPipeModule } from 'ng2-search-filter';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';

import { AddAnimalComponent } from './views/animals/add-animal/add-animal.component';
import { AddGroupsComponent } from './views/animals/add-groups/add-groups.component';
import { AddImageComponent } from './views/animals/add-image/add-image.component';
import { AddRangerComponent } from './views/rangers/add-ranger/add-ranger.component';
import { AnimalsComponent } from './views/animals/animals.component';
import { AnimalsGalleryComponent } from './views/animals/animals-gallery/animals-gallery.component';
import { AnimalsGalleryToolbarComponent } from './views/animals/animals-gallery/animals-gallery-toolbar/animals-gallery-toolbar.component';
import { AnimalsGalleryCardComponent } from './views/animals/animals-gallery/animals-gallery-card/animals-gallery-card.component';
import { AnimalInfoCardComponent } from './views/animals/animal-info-card/animal-info-card.component';
import { AnimalPhotosComponent } from './views/animals/animals-gallery/animal-photos/animal-photos.component';
import { AnimalPhotoDetailsComponent } from './views/animals/animals-gallery/animal-photos/animal-photo-details/animal-photo-details.component';
import { AnimalProfileComponent } from './views/animal-profile/animal-profile.component';
import { AnimalSearchSidenavComponent } from './views/animals/animal-search-sidenav/animal-search-sidenav.component';
import { AnimalStatisticsComponent } from './views/overview/animal-statistics/animal-statistics.component';
import { AnimalsToolbarComponent } from './views/animals/animals-toolbar/animals-toolbar.component';
import { AnimalTrackInfoComponent } from './views/animals/animals-gallery/animal-photos/animal-photo-details/animal-track-info/animal-track-info.component';
import { LoginComponent } from './views/login/login.component';
import { OverviewComponent } from './views/overview/overview.component';
import { EditAnimalInfoComponent } from './views/animals/edit-animal-info/edit-animal-info.component';
import { EditRangerInfoComponent } from './views/rangers/edit-ranger-info/edit-ranger-info.component';
import { DeleteRangerComponent } from './views/rangers/delete-ranger/delete-ranger.component';
import { RangerPermissionsComponent } from './views/ranger-permissions/ranger-permissions.component';
import { RangerProfileComponent } from './views/ranger-profile/ranger-profile.component';
import { RangerProfileCardComponent } from './views/rangers/ranger-profile-card/ranger-profile-card.component';
import { RangersComponent } from './views/rangers/rangers.component';
import { RangersToolbarComponent } from './views/rangers/rangers-toolbar/rangers-toolbar.component';
import { RangerSearchSidenavCompComponent } from './views/rangers/ranger-search-sidenav-comp/ranger-search-sidenav-comp.component';
import { RangerStatisticsComponent } from './views/overview/ranger-statistics/ranger-statistics.component';
import { ReclassifyTrackComponent } from './views/track-identifications/track-identifications-sidenav/track-identifications-info/reclassify-track/reclassify-track.component';
import { SideNavigationComponent } from './components/side-navigation/side-navigation.component';
import { TrackHeatmapOptionsComponent } from './views/track-identifications/track-identifications-sidenav/track-heatmap-options/track-heatmap-options.component';
import { TrackIdentificationsComponent } from './views/track-identifications/track-identifications.component';
import { TrackIdentificationsInfoComponent } from './views/track-identifications/track-identifications-sidenav/track-identifications-info/track-identifications-info.component';
import { TrackIdentificationsSidenavComponent } from './views/track-identifications/track-identifications-sidenav/track-identifications-sidenav.component';
import { TrackIdentificationsToolbarComponent } from './views/track-identifications/track-identifications-toolbar/track-identifications-toolbar.component';
import { UtilityNavigationComponent } from './components/utility-navigation/utility-navigation.component';

import { MatAutocompleteModule } from '@angular/material/autocomplete';
import { MatBadgeModule } from '@angular/material/badge';
import { MatButtonModule } from '@angular/material/button';
import { MatButtonToggleModule } from '@angular/material/button-toggle';
import { MatCardModule } from '@angular/material/card';
import { MatCheckboxModule } from '@angular/material/checkbox';
import { MatChipsModule } from '@angular/material/chips';
import { MatDatepickerModule } from '@angular/material/datepicker';
import { MatDialogModule } from '@angular/material/dialog';
import { MatDividerModule } from '@angular/material/divider';
import { MatGridListModule } from '@angular/material/grid-list';
import { MatExpansionModule } from '@angular/material/expansion';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatIconModule } from '@angular/material/icon';
import { MatInputModule } from '@angular/material/input';
import { MatListModule } from '@angular/material/list';
import { MatMenuModule } from '@angular/material/menu';
import { MatNativeDateModule } from '@angular/material/core';
import { MatPaginatorModule } from '@angular/material/paginator';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { MatRadioModule } from '@angular/material/radio';
import { MatSelectModule } from '@angular/material/select';
import { MatSidenavModule } from '@angular/material/sidenav';
import { MatSliderModule } from '@angular/material/slider';
import { MatSnackBarModule } from '@angular/material/snack-bar';
import { MatSortModule } from '@angular/material/sort';
import { MatStepperModule } from '@angular/material/stepper';
import { MatTableModule } from '@angular/material/table';
import { MatTabsModule } from '@angular/material/tabs';
import { MatTooltipModule } from '@angular/material/tooltip';

import { DragDropDirective } from './views/animals/add-image/drag-drop.directive';
import { GoogleMapsModule } from '@angular/google-maps';
import { NgxChartsModule } from '@swimlane/ngx-charts';
import { RelativeTimeMPipe } from './pipes/relative-time-m.pipe';

@NgModule({
  declarations: [
    AppComponent,
    AddRangerComponent,
    AddGroupsComponent,
    LoginComponent,
    OverviewComponent,
    AnimalsComponent,
    AnimalsGalleryComponent,
    AnimalsGalleryToolbarComponent,
    AnimalsGalleryCardComponent,
    AnimalGroupsComponent,
    AnimalPhotosComponent,
    AnimalPhotoDetailsComponent,
    AnimalTrackInfoComponent,
    AnimalsToolbarComponent,
    AnimalSearchSidenavComponent,
    AnimalInfoCardComponent,
    AddAnimalComponent,
    AnimalStatisticsComponent,
    DeleteRangerComponent,
    EditRangerInfoComponent,
    EditAnimalInfoComponent,
    RangersComponent,
    RangersToolbarComponent,
    RangerSearchSidenavCompComponent,
    RangerProfileCardComponent,
    RangerPermissionsComponent,
    RangerStatisticsComponent,
    RangerProfileComponent,
	ReclassifyTrackComponent,
    TrackHeatmapOptionsComponent,
    TrackIdentificationsComponent,
    TrackIdentificationsToolbarComponent,
    TrackIdentificationsSidenavComponent,
    TrackIdentificationsInfoComponent,
    SideNavigationComponent,
    UtilityNavigationComponent,
    AnimalProfileComponent,
    RelativeTimeMPipe,
    AddImageComponent,
    DragDropDirective
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
    MatMenuModule,
    MatListModule,
    MatCardModule,
    MatMenuModule,
    MatCheckboxModule,
    MatDialogModule,
    MatDatepickerModule,
    MatNativeDateModule,
    MatBadgeModule,
    MatExpansionModule,
    MatTableModule,
	MatTooltipModule,
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
    MatPaginatorModule,
    MatSelectModule,
    MatSidenavModule,
	MatSliderModule, 
	MatSortModule,
    GoogleMapsModule,
	NgxChartsModule
  ],
  providers: [AuthGuardService],
  entryComponents: [
    AddRangerComponent,
    EditRangerInfoComponent,
    DeleteRangerComponent,
    EditAnimalInfoComponent,
    AddAnimalComponent,
    AnimalPhotoDetailsComponent,
	ReclassifyTrackComponent
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }