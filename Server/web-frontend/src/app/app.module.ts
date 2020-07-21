import { AuthGuardService } from './services/auth-guard.service';
import { HttpClient, HttpClientModule } from '@angular/common/http';
import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
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
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { Ng2SearchPipeModule } from 'ng2-search-filter';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { LoginComponent } from './views/login/login.component';
import { OverviewComponent } from './views/overview/overview.component';
import { AnimalsComponent } from './views/animals/animals.component';
import { RangersComponent } from './views/rangers/rangers.component';
import { GeotagsComponent } from './views/geotags/geotags.component';
import { SettingsComponent } from './views/settings/settings.component';
import { SideNavigationComponent } from './components/side-navigation/side-navigation.component';
import { UtilityNavigationComponent } from './components/utility-navigation/utility-navigation.component';

@NgModule({
  declarations: [
    AppComponent,
    LoginComponent,
    OverviewComponent,
    AnimalsComponent,
    RangersComponent,
    GeotagsComponent,
    SettingsComponent,
    SideNavigationComponent,
    UtilityNavigationComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    BrowserAnimationsModule,
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
    FormsModule,
    ReactiveFormsModule,
    HttpClientModule,
    Ng2SearchPipeModule
  ],
  providers: [AuthGuardService],
  bootstrap: [AppComponent]
})
export class AppModule { }
