import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { ProfileComponent } from './pages/profile/profile.component';
import { LibraryComponent } from './pages/library/library.component';
import { TreeComponent } from './pages/tree/tree.component';
import { NodeComponent } from './pages/node/node.component';

@NgModule({
  declarations: [
    AppComponent,
    ProfileComponent,
    LibraryComponent,
    TreeComponent,
    NodeComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
