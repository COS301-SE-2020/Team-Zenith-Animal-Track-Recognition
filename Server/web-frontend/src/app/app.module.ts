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
import { AnimalsComponent } from './views/animals/animals.component';
import { RangersComponent } from './views/rangers/rangers.component';
import { RangersToolbarComponent } from './views/rangers/rangers-toolbar/rangers-toolbar.component';
import { RangerSearchSidenavCompComponent } from './views/rangers/ranger-search-sidenav-comp/ranger-search-sidenav-comp.component';
import { RangerProfileCardComponent } from './views/rangers/ranger-profile-card/ranger-profile-card.component';
import { AddRangerComponent } from './views/rangers/add-ranger/add-ranger.component';
import { EditRangerInfoComponent } from './views/rangers/edit-ranger-info/edit-ranger-info.component'; 
import { DeleteRangerComponent } from './views/rangers/delete-ranger/delete-ranger.component';
import { RangerPermissionsComponent } from './views/ranger-permissions/ranger-permissions.component';
import { GeotagsComponent } from './views/geotags/geotags.component';
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
import {MatCardModule} from '@angular/material/card'; 
import {MatMenuModule} from '@angular/material/menu'; 
import {MatDialogModule} from '@angular/material/dialog';
import {MatDatepickerModule} from '@angular/material/datepicker';
import {MatNativeDateModule} from '@angular/material/core';
import {MatBadgeModule} from '@angular/material/badge';
import {MatExpansionModule} from '@angular/material/expansion'; 
import {MatTableModule} from '@angular/material/table'; 
import {MatRadioModule} from '@angular/material/radio';

@NgModule({
  declarations: [
    AppComponent,
	AddRangerComponent,
    LoginComponent,
    OverviewComponent,
    AnimalsComponent,
    RangersComponent,
    RangersToolbarComponent,
    RangerSearchSidenavCompComponent,
    RangerProfileCardComponent,
    GeotagsComponent,
    SettingsComponent,
    SideNavigationComponent,
    UtilityNavigationComponent,
    RangerPermissionsComponent,
    EditRangerInfoComponent,
    DeleteRangerComponent,
    AnimalsToolbarComponent,
    AnimalSearchSidenavComponent,
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
	MatRadioModule
  ],
  providers: [AuthGuardService],
  entryComponents: [AddRangerComponent, EditRangerInfoComponent, DeleteRangerComponent],
  bootstrap: [AppComponent]
})
export class AppModule { }
